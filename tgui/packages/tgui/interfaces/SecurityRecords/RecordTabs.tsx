import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useBackend, useLocalState } from 'tgui/backend';
import { Stack, Input, Section, Tabs, NoticeBox, Box, Icon, Button } from 'tgui/components';
import { JOB2ICON } from '../common/JobToIcon';
import { CRIMESTATUS2COLOR } from './constants';
import { isRecordMatch } from './helpers';
import { SecurityRecordsData, SecurityRecord } from './types';

/** Tabs on left, with search bar */
export const SecurityRecordTabs = (props, context) => {
  const { act, data } = useBackend<SecurityRecordsData>(context);
  const { higher_access, records = [], station_z } = data;

  const errorMessage = !records.length
    ? 'Aucun casiers trouvé.'
    : 'Aucun résultats, rafinez votre recherche.';

  const [search, setSearch] = useLocalState(context, 'search', '');

  const sorted: SecurityRecord[] = flow([
    filter((record: SecurityRecord) => isRecordMatch(record, search)),
    sortBy((record: SecurityRecord) => record.name),
  ])(records);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Input
          fluid
          placeholder="Name/Job/Fingerprints"
          onInput={(event, value) => setSearch(value)}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Tabs vertical>
            {!sorted.length ? (
              <NoticeBox>{errorMessage}</NoticeBox>
            ) : (
              sorted.map((record, index) => (
                <CrewTab record={record} key={index} />
              ))
            )}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item align="center">
        <Stack fill>
          <Stack.Item>
            <Button
              disabled
              icon="plus"
              tooltip="Ajoutez un nouveau casier en insérant une photo de 1 mètre par 1 mètre dans le terminal. Vous n'avez pas besoin de cette fenêtre ouverte..">
              Créer
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm
              content="Purger"
              disabled={!higher_access || !station_z}
              icon="trash"
              onClick={() => act('purge_records')}
              tooltip="Supprimez un casier judiciaire."
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

/** Individual record */
const CrewTab = (props: { record: SecurityRecord }, context) => {
  const [selectedRecord, setSelectedRecord] = useLocalState<
    SecurityRecord | undefined
  >(context, 'securityRecord', undefined);

  const { act, data } = useBackend<SecurityRecordsData>(context);
  const { assigned_view } = data;
  const { record } = props;
  const { crew_ref, name, rank, wanted_status } = record;

  /** Chooses a record */
  const selectRecord = (record: SecurityRecord) => {
    if (selectedRecord?.crew_ref === crew_ref) {
      setSelectedRecord(undefined);
    } else {
      setSelectedRecord(record);
      act('view_record', { assigned_view: assigned_view, crew_ref: crew_ref });
    }
  };

  const isSelected = selectedRecord?.crew_ref === crew_ref;

  return (
    <Tabs.Tab
      className="candystripe"
      label={record.name}
      onClick={() => selectRecord(record)}
      selected={isSelected}>
      <Box bold={isSelected} color={CRIMESTATUS2COLOR[wanted_status]} wrap>
        <Icon name={JOB2ICON[rank] || 'question'} /> {name}
      </Box>
    </Tabs.Tab>
  );
};
