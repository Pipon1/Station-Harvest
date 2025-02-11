import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  current_user: string;
  card_owner: string;
  paperamt: number;
  barcode_split: number;
  has_id_slot: BooleanLike;
};

export const NtosShipping = (props, context) => {
  return (
    <NtosWindow width={450} height={350}>
      <NtosWindow.Content scrollable>
        <ShippingHub />
        <ShippingOptions />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

/** Returns information about the current user, available paper, etc */
const ShippingHub = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { current_user, card_owner, paperamt, barcode_split } = data;

  return (
    <Section
      title="Menu de commande de Nanotrasen."
      buttons={
        <Button
          icon="eject"
          content="Ejecter l'ID"
          onClick={() => act('ejectid')}
        />
      }>
      <LabeledList>
        <LabeledList.Item label="Utilisateur actuel">
          {current_user || 'N/A'}
        </LabeledList.Item>
        <LabeledList.Item label="Carte insérée">
          {card_owner || 'N/A'}
        </LabeledList.Item>
        <LabeledList.Item label="Papier disponible">{paperamt}</LabeledList.Item>
        <LabeledList.Item label="Profit en action">
          {barcode_split}%
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

/** Returns shipping options */
const ShippingOptions = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { has_id_slot, current_user } = data;

  return (
    <Section title="Options de livraison">
      <Box>
        <Button
          icon="id-card"
          tooltip="L'ID actuel deviendra l'utilisateur actuel."
          tooltipPosition="right"
          disabled={!has_id_slot}
          onClick={() => act('selectid')}
          content="Définir l'ID actuel"
        />
      </Box>
      <Box>
        <Button
          icon="print"
          tooltip="Imprime un code-barres à utiliser sur un colis emballé."
          tooltipPosition="right"
          disabled={!current_user}
          onClick={() => act('print')}
          content="Imprimer un code-barres"
        />
      </Box>
      <Box>
        <Button
          icon="tags"
          tooltip="Définir le prix du colis."
          tooltipPosition="right"
          onClick={() => act('setsplit')}
          content="Définir le prix"
        />
      </Box>
      <Box>
        <Button
          icon="sync-alt"
          content="Réinitialiser l'ID."
          onClick={() => act('resetid')}
        />
      </Box>
    </Section>
  );
};
