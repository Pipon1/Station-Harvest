import { useBackend, useSharedState } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Icon, Section, Stack, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export const NtosNetMonitor = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab_main, setTab_main] = useSharedState(context, 'tab_main', 1);
  const {
    ntnetrelays,
    idsalarm,
    idsstatus,
    ntnetlogs = [],
    tablets = [],
  } = data;
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Stack.Item>
          <Tabs>
            <Tabs.Tab
              icon="network-wired"
              lineHeight="23px"
              selected={tab_main === 1}
              onClick={() => setTab_main(1)}>
              NtNet
            </Tabs.Tab>
            <Tabs.Tab
              icon="tablet"
              lineHeight="23px"
              selected={tab_main === 2}
              onClick={() => setTab_main(2)}>
              Tablette ({tablets.length})
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        {tab_main === 1 && (
          <Stack.Item>
            <MainPage
              ntnetrelays={ntnetrelays}
              idsalarm={idsalarm}
              idsstatus={idsstatus}
              ntnetlogs={ntnetlogs}
            />
          </Stack.Item>
        )}
        {tab_main === 2 && (
          <Stack.Item>
            <TabletPage tablets={tablets} />
          </Stack.Item>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const MainPage = (props, context) => {
  const { ntnetrelays, idsalarm, idsstatus, ntnetlogs = [] } = props;
  const { act, data } = useBackend(context);
  return (
    <Section>
      <NoticeBox>
        ATTENTION: Désactiver les émetteurs sans fil lors de l'utilisation d'un appareil sans fil
        peut vous empêcher de les réactiver !
      </NoticeBox>
      <Section title="Connexion sans-fil">
        {ntnetrelays.map((relay) => (
          <Section
            key={relay.ref}
            title={relay.name}
            buttons={
              <Button.Confirm
                color={relay.is_operational ? 'good' : 'bad'}
                content={relay.is_operational ? 'ACTIVE' : 'DESACTIVE'}
                onClick={() =>
                  act('toggle_relay', {
                    ref: relay.ref,
                  })
                }
              />
            }
          />
        ))}
      </Section>
      <Section title="Système de sécurité">
        {!!idsalarm && (
          <>
            <NoticeBox>INTRUSION DU SYSTEME DETECTEE</NoticeBox>
            <Box italics>
              Activité anormale détectée dans le réseau.
              Vérifiez les logs système pour plus d'informations
            </Box>
          </>
        )}
        <LabeledList>
          <LabeledList.Item
            label="Statut de l'IDS"
            buttons={
              <>
                <Button
                  icon={idsstatus ? 'power-off' : 'times'}
                  content={idsstatus ? 'ACTIVE' : 'DESTACTIVE'}
                  selected={idsstatus}
                  onClick={() => act('toggleIDS')}
                />
                <Button
                  icon="sync"
                  content="Redémarrer"
                  color="bad"
                  onClick={() => act('resetIDS')}
                />
              </>
            }
          />
        </LabeledList>
        <Section
          title="Log système"
          buttons={
            <Button.Confirm
              icon="trash"
              content="Vider les logs"
              onClick={() => act('purgelogs')}
            />
          }>
          {ntnetlogs.map((log) => (
            <Box key={log.entry} className="candystripe">
              {log.entry}
            </Box>
          ))}
        </Section>
      </Section>
    </Section>
  );
};

const TabletPage = (props, context) => {
  const { tablets } = props;
  const { act, data } = useBackend(context);
  if (!tablets.length) {
    return <NoticeBox>No tablets detected.</NoticeBox>;
  }
  return (
    <Section>
      <Stack vertical mt={1}>
        <Section fill textAlign="center">
          <Icon name="comment" mr={1} />
          Active Tablets
        </Section>
      </Stack>
      <Stack vertical mt={1}>
        <Section fill>
          <Stack vertical>
            {tablets.map((tablet) => (
              <Section
                key={tablet.ref}
                title={tablet.name}
                buttons={
                  <Button.Confirm
                    icon={tablet.enabled_spam ? 'unlock' : 'lock'}
                    color={tablet.enabled_spam ? 'good' : 'default'}
                    content={
                      tablet.enabled_spam
                        ? 'Autoriser le spam'
                        : 'Désautoriser le spam'
                    }
                    onClick={() =>
                      act('toggle_mass_pda', {
                        ref: tablet.ref,
                      })
                    }
                  />
                }
              />
            ))}
          </Stack>
        </Section>
      </Stack>
    </Section>
  );
};
