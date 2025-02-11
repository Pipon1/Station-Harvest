import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button } from '../components';
import { NtosWindow } from '../layouts';
import { GasAnalyzerContent, GasAnalyzerData } from './GasAnalyzer';

type NtosGasAnalyzerData = GasAnalyzerData & {
  atmozphereMode: 'click' | 'env';
  clickAtmozphereCompatible: BooleanLike;
};

export const NtosGasAnalyzer = (props, context) => {
  const { act, data } = useBackend<NtosGasAnalyzerData>(context);
  const { atmozphereMode, clickAtmozphereCompatible } = data;
  return (
    <NtosWindow width={500} height={450}>
      <NtosWindow.Content scrollable>
        {!!clickAtmozphereCompatible && (
          <Button
            icon={'sync'}
            onClick={() => act('scantoggle')}
            fluid
            textAlign="center"
            tooltip={
              atmozphereMode === 'click'
                ? 'Clique-droit sur les objets tout en tenant la tablette pour les scanner. Clique-droit sur la tablette pour scanner l\'emplacement actuel.'
                : "Cette application mettra à jour automatiquement la lecture du mélange gazeux."
            }
            tooltipPosition="bottom">
            {atmozphereMode === 'click'
              ? 'Scan des objets séléctionner. Cliquer pour changer.'
              : 'Scan votre position actuelle. Cliquer pour changer.'}
          </Button>
        )}
        <GasAnalyzerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
