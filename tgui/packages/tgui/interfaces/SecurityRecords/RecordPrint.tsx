import { useBackend, useLocalState } from 'tgui/backend';
import { PRINTOUT, SecurityRecordsData } from './types';
import { Box, Button, Input, Section, Stack } from 'tgui/components';
import { getSecurityRecord, getDefaultPrintDescription, getDefaultPrintHeader } from './helpers';

/** Handles printing posters and rapsheets */
export const RecordPrint = (props, context) => {
  const foundRecord = getSecurityRecord(context);
  if (!foundRecord) return <> </>;

  const { crew_ref, crimes, name } = foundRecord;
  const innocent = !crimes?.length;
  const { act } = useBackend<SecurityRecordsData>(context);

  const [open, setOpen] = useLocalState<boolean>(context, 'printOpen', true);
  const [alias, setAlias] = useLocalState<string>(context, 'printAlias', name);

  const [printType, setPrintType] = useLocalState<PRINTOUT>(
    context,
    'printType',
    PRINTOUT.Missing
  );
  const [header, setHeader] = useLocalState<string>(context, 'printHeader', '');
  const [description, setDescription] = useLocalState<string>(
    context,
    'printDesc',
    ''
  );

  /** Prints the record and resets. */
  const printSheet = () => {
    act('print_record', {
      alias: alias,
      crew_ref: crew_ref,
      desc: description,
      head: header,
      type: printType,
    });
    reset();
  };

  /** Close everything and reset to blank. */
  const reset = () => {
    setAlias('');
    setHeader('');
    setDescription('');
    setPrintType(PRINTOUT.Missing);
    setOpen(false);
  };

  /** Clears the value and sets it to default. */
  const clearField = (field: string) => {
    switch (field) {
      case 'alias':
        setAlias(name);
        break;
      case 'header':
        setHeader(getDefaultPrintHeader(printType));
        break;
      case 'description':
        setDescription(getDefaultPrintDescription(name, printType));
        break;
    }
  };

  /** If they have the fields defaulted to a specific type, change the message */
  const swapTabs = (tab: PRINTOUT) => {
    if (description === getDefaultPrintDescription(name, printType)) {
      setDescription(getDefaultPrintDescription(name, tab));
    }
    if (header === getDefaultPrintHeader(printType)) {
      setHeader(getDefaultPrintHeader(tab));
    }
    setPrintType(tab);
  };

  return (
    <Section
      buttons={
        <>
          <Button
            icon="question"
            onClick={() => swapTabs(PRINTOUT.Missing)}
            selected={printType === PRINTOUT.Missing}
            tooltip="Imprime un poster avec une photo du suspect."
            tooltipPosition="bottom">
            Disparu
          </Button>
          <Button
            disabled={innocent}
            icon="file-alt"
            onClick={() => swapTabs(PRINTOUT.Rapsheet)}
            selected={printType === PRINTOUT.Rapsheet}
            tooltip={`Imprime le casier judiciaire du suspect. ${
              innocent && ' (Requires crimes)'
            }`}
            tooltipPosition="bottom">
            Casier Judiciaire
          </Button>
          <Button
            disabled={innocent}
            icon="handcuffs"
            onClick={() => swapTabs(PRINTOUT.Wanted)}
            selected={printType === PRINTOUT.Wanted}
            tooltip={`Imprime un poster avec une photo du suspect et une description de son crime.${
              innocent && ' (Requires crimes)'
            }`}
            tooltipPosition="bottom">
            Recherché
          </Button>
          <Button color="bad" icon="times" onClick={reset} />
        </>
      }
      fill
      scrollable
      title="Imprimer un casier">
      <Stack color="label" fill vertical>
        <Stack.Item>
          <Box>Entrez un dessus de page : </Box>
          <Input
            onChange={(event, value) => setHeader(value)}
            maxLength={7}
            value={header}
          />
          <Button
            icon="sync"
            onClick={() => clearField('header')}
            tooltip="Reset"
          />
        </Stack.Item>
        <Stack.Item>
          <Box>Entrez un alias : </Box>
          <Input
            onChange={(event, value) => setAlias(value)}
            maxLength={42}
            value={alias}
            width="55%"
          />
          <Button
            icon="sync"
            onClick={() => clearField('alias')}
            tooltip="Reset"
          />
        </Stack.Item>
        <Stack.Item>
          <Box>Entrez une description : </Box>
          <Stack fill>
            <Stack.Item grow>
              <Input
                fluid
                maxLength={150}
                onChange={(event, value) => setDescription(value)}
                value={description}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="sync"
                onClick={() => clearField('description')}
                tooltip="Reset"
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item mt={2}>
          <Box align="right">
            <Button color="bad" onClick={() => setOpen(false)}>
              Cancel
            </Button>
            <Button color="good" onClick={printSheet}>
              Print
            </Button>
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
