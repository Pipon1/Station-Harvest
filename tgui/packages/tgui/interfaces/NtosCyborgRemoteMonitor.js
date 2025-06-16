import { useBackend, useSharedState } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section, Stack, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export const NtosCyborgRemoteMonitor = (props, context) => {
  return (
    <NtosWindow width={600} height={800}>
      <NtosWindow.Content>
        <NtosCyborgRemoteMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ProgressSwitch = (param) => {
  switch (param) {
    case -1:
      return '_';
    case 0:
      return 'Connecting';
    case 25:
      return 'Starting Transfer';
    case 50:
      return 'Downloading';
    case 75:
      return 'Downloading';
    case 100:
      return 'Formatting';
  }
};

export const NtosCyborgRemoteMonitorContent = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab_main, setTab_main] = useSharedState(context, 'tab_main', 1);
  const { card, cyborgs = [], DL_progress } = data;
  const storedlog = data.borglog || [];

  if (!cyborgs.length) {
    return <NoticeBox>Aucun cyborg détecté.</NoticeBox>;
  }

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Tabs>
          <Tabs.Tab
            icon="robot"
            lineHeight="23px"
            selected={tab_main === 1}
            onClick={() => setTab_main(1)}>
            Cyborgs
          </Tabs.Tab>
          <Tabs.Tab
            icon="clipboard"
            lineHeight="23px"
            selected={tab_main === 2}
            onClick={() => setTab_main(2)}>
            Stocké dans le fichier de log
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      {tab_main === 1 && (
        <>
          {!card && (
            <Stack.Item>
              <NoticeBox>Certaines app demande une connexion par ID.</NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item grow={1}>
            <Section fill scrollable>
              {cyborgs.map((cyborg) => (
                <Section
                  key={cyborg.ref}
                  title={cyborg.name}
                  buttons={
                    <Button
                      icon="terminal"
                      content="Envoyer un mesage"
                      color="blue"
                      disabled={!card}
                      onClick={() =>
                        act('messagebot', {
                          ref: cyborg.ref,
                        })
                      }
                    />
                  }>
                  <LabeledList>
                    <LabeledList.Item label="Statut">
                      <Box
                        color={
                          cyborg.status
                            ? 'bad'
                            : cyborg.locked_down
                              ? 'average'
                              : 'good'
                        }>
                        {cyborg.status
                          ? 'Ne répond pas'
                          : cyborg.locked_down
                            ? 'Vérouillé'
                            : cyborg.shell_discon
                              ? 'Nominal/Déconnecté'
                              : 'Nominal'}
                      </Box>
                    </LabeledList.Item>
                    <LabeledList.Item label="Etat">
                      <Box
                        color={
                          cyborg.integ <= 25
                            ? 'bad'
                            : cyborg.integ <= 75
                              ? 'average'
                              : 'good'
                        }>
                        {cyborg.integ === 0
                          ? 'Dégât critique'
                          : cyborg.integ <= 25
                            ? 'Fonctionnalité réduite'
                            : cyborg.integ <= 75
                              ? 'Fontionnel avec des dommages mineurs'
                              : 'Fontionnel'}
                      </Box>
                    </LabeledList.Item>
                    <LabeledList.Item label="Recharge">
                      <Box
                        color={
                          cyborg.charge <= 30
                            ? 'bad'
                            : cyborg.charge <= 70
                              ? 'average'
                              : 'good'
                        }>
                        {typeof cyborg.charge === 'number'
                          ? cyborg.charge + '%'
                          : 'Not Found'}
                      </Box>
                    </LabeledList.Item>
                    <LabeledList.Item label="Modèle">
                      {cyborg.module}
                    </LabeledList.Item>
                    <LabeledList.Item label="Améliorations">
                      {cyborg.upgrades}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              ))}
            </Section>
          </Stack.Item>
        </>
      )}
      {tab_main === 2 && (
        <>
          <Stack.Item>
            <Section>
              Scanez un cyborg pour voir les logs.
              <ProgressBar value={DL_progress / 100}>
                {ProgressSwitch(DL_progress)}
              </ProgressBar>
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Section fill scrollable backgroundColor="black">
              {storedlog.map((log) => (
                <Box mb={1} key={log} color="green">
                  {log}
                </Box>
              ))}
            </Section>
          </Stack.Item>
        </>
      )}
    </Stack>
  );
};
