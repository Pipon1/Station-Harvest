import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const Apc = (props, context) => {
  return (
    <Window width={450} height={445}>
      <Window.Content scrollable>
        <ApcContent />
      </Window.Content>
    </Window>
  );
};

const powerStatusMap = {
  2: {
    color: 'good',
    externalPowerText: 'Courant Externe',
    chargingText: 'Charge Complète',
  },
  1: {
    color: 'average',
    externalPowerText: 'Courant Externe Faible',
    chargingText: 'En Charge',
  },
  0: {
    color: 'bad',
    externalPowerText: 'Aucun Courant Externe',
    chargingText: 'Aucun Courant',
  },
};

const malfMap = {
  1: {
    icon: 'terminal',
    content: 'Pirater le terminal',
    action: 'hack',
  },
  2: {
    icon: 'caret-square-down',
    content: 'Déplacer le coeur de l\'IA',
    action: 'occupy',
  },
  3: {
    icon: 'caret-square-left',
    content: 'Retourner le coeur au satellite',
    action: 'deoccupy',
  },
  4: {
    icon: 'caret-square-down',
    content: 'Déplacer le coeur de l\'IA',
    action: 'occupy',
  },
};

const ApcContent = (props, context) => {
  const { act, data } = useBackend(context);
  const locked = data.locked && !data.siliconUser;
  const externalPowerStatus =
    powerStatusMap[data.externalPower] || powerStatusMap[0];
  const chargingStatus =
    powerStatusMap[data.chargingStatus] || powerStatusMap[0];
  const channelArray = data.powerChannels || [];
  const malfStatus = malfMap[data.malfStatus] || malfMap[0];
  const adjustedCellChange = data.powerCellStatus / 100;
  if (data.failTime > 0) {
    return (
      <NoticeBox info textAlign="center" mb={0}>
        <b>
          <h3>ECHEC DU SYSTEM</h3>
        </b>
        Les régulateurs d'I/O ont malfonctionné ! <br />
        En attente d'un redémarrage system.
        <br />
        Exécution du logiciel de redémarrage dans {data.failTime} secondes...
        <br />
        <br />
        <Button
          icon="sync"
          content="Redémarrer Maintenant"
          tooltip="Force un redémarrage de l'interface."
          tooltipPosition="bottom"
          onClick={() => act('reboot')}
        />
      </NoticeBox>
    );
  }
  return (
    <>
      <InterfaceLockNoticeBox
        siliconUser={data.remoteAccess || data.siliconUser}
        preventLocking={data.remoteAccess}
      />
      <Section title="Etat De La Batterie">
        <LabeledList>
          <LabeledList.Item
            label="Disjoncteur Principal"
            color={externalPowerStatus.color}
            buttons={
              <Button
                icon={data.isOperating ? 'power-off' : 'times'}
                content={data.isOperating ? 'On' : 'Off'}
                selected={data.isOperating && !locked}
                disabled={locked}
                onClick={() => act('breaker')}
              />
            }>
            [ {externalPowerStatus.externalPowerText} ]
          </LabeledList.Item>
          <LabeledList.Item label="Batterie">
            <ProgressBar color="good" value={adjustedCellChange} />
          </LabeledList.Item>
          <LabeledList.Item
            label="Etat Du Chargement"
            color={chargingStatus.color}
            buttons={
              <Button
                icon={data.chargeMode ? 'sync' : 'times'}
                content={data.chargeMode ? 'Auto' : 'Off'}
                disabled={locked}
                onClick={() => act('charge')}
              />
            }>
            [ {chargingStatus.chargingText} ]
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Status Du Réseau Eléctrique">
        <LabeledList>
          {channelArray.map((channel) => {
            const { topicParams } = channel;
            return (
              <LabeledList.Item
                key={channel.title}
                label={channel.title}
                buttons={
                  <>
                    <Box
                      inline
                      mx={2}
                      color={channel.status >= 2 ? 'good' : 'bad'}>
                      {channel.status >= 2 ? 'On' : 'Off'}
                    </Box>
                    <Button
                      icon="sync"
                      content="Auto"
                      selected={
                        !locked &&
                        (channel.status === 1 || channel.status === 3)
                      }
                      disabled={locked}
                      onClick={() => act('channel', topicParams.auto)}
                    />
                    <Button
                      icon="power-off"
                      content="On"
                      selected={!locked && channel.status === 2}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.on)}
                    />
                    <Button
                      icon="times"
                      content="Off"
                      selected={!locked && channel.status === 0}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.off)}
                    />
                  </>
                }>
                {channel.powerLoad}
              </LabeledList.Item>
            );
          })}
          <LabeledList.Item label="Charge Totale">
            <b>{data.totalLoad}</b>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Autre"
        buttons={
          !!data.siliconUser && (
            <>
              {!!data.malfStatus && (
                <Button
                  icon={malfStatus.icon}
                  content={malfStatus.content}
                  color="bad"
                  onClick={() => act(malfStatus.action)}
                />
              )}
              <Button
                icon="lightbulb-o"
                content="Surcharger"
                onClick={() => act('overload')}
              />
            </>
          )
        }>
        <LabeledList>
          <LabeledList.Item
            label="Vérrou Du Couvercle"
            buttons={
              <Button
                tooltip="Le couvercle du CEL peut être forcé avec un pied de biche."
                icon={data.coverLocked ? 'lock' : 'unlock'}
                content={data.coverLocked ? 'Vérouillé' : 'Dévérouillé'}
                disabled={locked}
                onClick={() => act('cover')}
              />
            }
          />
          <LabeledList.Item
            label="Eclairage d'Urgence"
            buttons={
              <Button
                tooltip="Ces lumières utilisent la batterie interne quand il n'y pas de courant."
                icon="lightbulb-o"
                content={data.emergencyLights ? 'Activé' : 'Désactivé'}
                disabled={locked}
                onClick={() => act('emergency_lighting')}
              />
            }
          />
          <LabeledList.Item
            label="Lumière De Nuit"
            buttons={
              <Button
                tooltip="Des lumières atténuées pour réduire l'utilisation d'éléctricité."
                icon="lightbulb-o"
                content={data.nightshiftLights ? 'Activé' : 'Désactivé'}
                disabled={data.disable_nightshift_toggle}
                onClick={() => act('toggle_nightshift')}
              />
            }
          />
        </LabeledList>
      </Section>
    </>
  );
};
