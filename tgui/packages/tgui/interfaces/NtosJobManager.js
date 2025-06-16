import { useBackend } from '../backend';
import { Button, Section, Table, NoticeBox, Dimmer, Box } from '../components';
import { NtosWindow } from '../layouts';

export const NtosJobManager = (props, context) => {
  return (
    <NtosWindow width={400} height={620}>
      <NtosWindow.Content scrollable>
        <NtosJobManagerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosJobManagerContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { authed, cooldown, slots = [], prioritized = [] } = data;
  if (!authed) {
    return (
      <NoticeBox>
        Votre ID actuel n'a pas les permissions pour changer de travail.
      </NoticeBox>
    );
  }
  return (
    <Section>
      {cooldown > 0 && (
        <Dimmer>
          <Box bold textAlign="center" fontSize="20px">
            En cours de rechargement : {cooldown}s
          </Box>
        </Dimmer>
      )}
      <Table>
        <Table.Row header>
          <Table.Cell>Prioritiser</Table.Cell>
          <Table.Cell>Emplacement</Table.Cell>
        </Table.Row>
        {slots.map((slot) => (
          <Table.Row key={slot.title} className="candystripe">
            <Table.Cell bold>
              <Button.Checkbox
                fluid
                content={slot.title}
                disabled={slot.total <= 0}
                checked={slot.total > 0 && prioritized.includes(slot.title)}
                onClick={() =>
                  act('PRG_priority', {
                    target: slot.title,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell collapsing>
              {slot.current} / {slot.total}
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                content="Ouvrir"
                disabled={!slot.status_open}
                onClick={() =>
                  act('PRG_open_job', {
                    target: slot.title,
                  })
                }
              />
              <Button
                content="Fermer"
                disabled={!slot.status_close}
                onClick={() =>
                  act('PRG_close_job', {
                    target: slot.title,
                  })
                }
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
