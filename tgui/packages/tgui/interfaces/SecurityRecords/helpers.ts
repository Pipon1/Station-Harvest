import { useBackend, useLocalState } from 'tgui/backend';
import { PRINTOUT, SecurityRecordsData, SecurityRecord } from './types';

/** We need an active reference and this a pain to rewrite */
export const getSecurityRecord = (context) => {
  const [selectedRecord] = useLocalState<SecurityRecord | undefined>(
    context,
    'securityRecord',
    undefined
  );
  if (!selectedRecord) return;
  const { data } = useBackend<SecurityRecordsData>(context);
  const { records = [] } = data;
  const foundRecord = records.find(
    (record) => record.crew_ref === selectedRecord.crew_ref
  );
  if (!foundRecord) return;

  return foundRecord;
};

// Lazy type union
type GenericRecord = {
  name: string;
  rank: string;
  fingerprint?: string;
  dna?: string;
};

/** Matches search by fingerprint, dna, job, or name */
export const isRecordMatch = (record: GenericRecord, search: string) => {
  if (!search) return true;
  const { name, rank, fingerprint, dna } = record;

  switch (true) {
    case name?.toLowerCase().includes(search?.toLowerCase()):
    case rank?.toLowerCase().includes(search?.toLowerCase()):
    case fingerprint?.toLowerCase().includes(search?.toLowerCase()):
    case dna?.toLowerCase().includes(search?.toLowerCase()):
      return true;

    default:
      return false;
  }
};

/** Returns a string header based on print type */
export const getDefaultPrintHeader = (printType: PRINTOUT) => {
  switch (printType) {
    case PRINTOUT.Rapsheet:
      return 'Record';
    case PRINTOUT.Wanted:
      return 'WANTED';
    case PRINTOUT.Missing:
      return 'MISSING';
  }
};

/** Returns a string description based on print type */
export const getDefaultPrintDescription = (
  name: string,
  printType: PRINTOUT
) => {
  switch (printType) {
    case PRINTOUT.Rapsheet:
      return `Un casier judiciaire standard au nom de ${name}.`;
    case PRINTOUT.Wanted:
      return `Un poster déclarant ${name} comme étant un criminel recherché par Nanotrasen. Si vous le voyez veuillez immédiatement prévenir la sécurité.`;
    case PRINTOUT.Missing:
      return `Un poster déclarant ${name} comment étant disparu et recherché par Nanotrasen. Si vous le voyez veuillez immédiatement prévenir la sécurité.`;
  }
};
