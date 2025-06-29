import { useBackend, useLocalState } from '../backend';
import { NtosWindow } from '../layouts';
import { SupermatterContent, SupermatterData } from './Supermatter';
import { Button, ProgressBar, Section, Table } from '../components';

type NtosSupermatterData = SupermatterData & { focus_uid?: number };

export const NtosSupermatter = (props, context) => {
  const { act, data } = useBackend<NtosSupermatterData>(context);
  const { sm_data, gas_metadata, focus_uid } = data;
  const [activeUID, setActiveUID] = useLocalState(context, 'activeUID', 0);
  const activeSM = sm_data.find((sm) => sm.uid === activeUID);
  return (
    <NtosWindow height={400} width={700}>
      <NtosWindow.Content>
        {activeSM ? (
          <SupermatterContent
            {...activeSM}
            gas_metadata={gas_metadata}
            sectionButton={
              <Button icon="arrow-left" onClick={() => setActiveUID(0)}>
                Back
              </Button>
            }
          />
        ) : (
          <Section
            title="Super matières détectées"
            buttons={
              <Button
                icon="sync"
                content="Rafraichir"
                onClick={() => act('PRG_refresh')}
              />
            }>
            <Table>
              {sm_data.map((sm) => (
                <Table.Row key={sm.uid}>
                  <Table.Cell>{sm.uid + '. ' + sm.area_name}</Table.Cell>
                  <Table.Cell collapsing color="label">
                    Intégrité :
                  </Table.Cell>
                  <Table.Cell collapsing width="120px">
                    <ProgressBar
                      value={sm.integrity / 100}
                      ranges={{
                        good: [0.9, Infinity],
                        average: [0.5, 0.9],
                        bad: [-Infinity, 0.5],
                      }}
                    />
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      icon="bell"
                      color={focus_uid === sm.uid && 'yellow'}
                      onClick={() => act('PRG_focus', { 'focus_uid': sm.uid })}
                    />
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      content="Détails"
                      onClick={() => setActiveUID(sm.uid)}
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
