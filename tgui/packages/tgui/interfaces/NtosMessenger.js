import { useBackend, useLocalState } from '../backend';
import { createSearch } from 'common/string';
import { Box, Button, Dimmer, Icon, Section, Stack, Input } from '../components';
import { NtosWindow } from '../layouts';

const NoIDDimmer = (props, context) => {
  const { act, data } = useBackend(context);
  const { owner } = data;
  return (
    <Stack>
      <Stack.Item>
        <Dimmer>
          <Stack align="baseline" vertical>
            <Stack.Item>
              <Stack ml={-2}>
                <Stack.Item>
                  <Icon color="red" name="address-card" size={10} />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item fontSize="18px">
              S'il vous plaît, enregistrez votre ID pour continuer.
            </Stack.Item>
          </Stack>
        </Dimmer>
      </Stack.Item>
    </Stack>
  );
};

export const NtosMessenger = (props, context) => {
  const { act, data } = useBackend(context);
  const { viewing_messages } = data;
  if (viewing_messages) {
    return <MessageListScreen />;
  }
  return <ContactsScreen />;
};

const ContactsScreen = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    owner,
    ringer_status,
    sending_and_receiving,
    messengers = [],
    sortByJob,
    canSpam,
    isSilicon,
    photo,
    virus_attach,
    sending_virus,
  } = data;
  const [searchUser, setSearchUser] = useLocalState(context, 'searchUser', '');
  const search = createSearch(
    searchUser,
    (messengers) => messengers.name + messengers.job
  );
  let users =
    searchUser.length > 0 ? data.messengers.filter(search) : messengers;
  return (
    <NtosWindow width={600} height={800}>
      <NtosWindow.Content scrollable>
        <Stack vertical>
          <Section fill textAlign="center">
            <Box bold>
              <Icon name="address-card" mr={1} />
              MessagerDelEspace V6.4.8
            </Box>
            <Box italic opacity={0.3}>
              Vous fournit des communications à l'épreuve des espions depuis 2467.
            </Box>
          </Section>
        </Stack>
        <Stack vertical>
          <Section fill textAlign="center">
            <Box>
              <Button
                icon="bell"
                content={ringer_status ? 'Sonnerie : On' : 'Sonnerie : Off'}
                onClick={() => act('PDA_ringer_status')}
              />
              <Button
                icon="address-card"
                content={
                  sending_and_receiving
                    ? 'Envoyer / Recevoir : On'
                    : 'Envoyer / Recevoir : Off'
                }
                onClick={() => act('PDA_sAndR')}
              />
              <Button
                icon="bell"
                content="Définir la sonnerie"
                onClick={() => act('PDA_ringSet')}
              />
              <Button
                icon="comment"
                content="Voir les messages"
                onClick={() => act('PDA_viewMessages')}
              />
              <Button
                icon="sort"
                content={`Trier par : ${sortByJob ? 'Travail' : 'Nom'}`}
                onClick={() => act('PDA_changeSortStyle')}
              />
              {!!isSilicon && (
                <Button
                  icon="camera"
                  content="Attacher une image"
                  onClick={() => act('PDA_selectPhoto')}
                />
              )}
              {!!virus_attach && (
                <Button
                  icon="bug"
                  color="bad"
                  content={`Attacher un virus : ${sending_virus ? 'Oui' : 'Non'}`}
                  onClick={() => act('PDA_toggleVirus')}
                />
              )}
            </Box>
          </Section>
        </Stack>
        {!!photo && (
          <Stack vertical mt={1}>
            <Section fill textAlign="center">
              <Icon name="camera" mr={1} />
              Photo actuelle
            </Section>
            <Section align="center">
              <Button onClick={() => act('PDA_clearPhoto')}>
                <Box mt={1} as="img" src={photo ? photo : null} />
              </Button>
            </Section>
          </Stack>
        )}
        <Stack vertical mt={1}>
          <Section fill textAlign="center">
            <Icon name="address-card" mr={1} />
            Utilisateurs détectés
            <Input
              width="220px"
              placeholder="Chercher par nom ou par travail"
              value={searchUser}
              onInput={(e, value) => setSearchUser(value)}
              mx={1}
              ml={27}
            />
          </Section>
        </Stack>
        <Stack vertical mt={1}>
          <Section fill>
            <Stack vertical>
              {users.length === 0 && 'Aucun utilisateur trouvé'}
              {users.map((messenger) => (
                <Button
                  key={messenger.ref}
                  fluid
                  onClick={() =>
                    act('PDA_sendMessage', {
                      name: messenger.name,
                      job: messenger.job,
                      ref: messenger.ref,
                    })
                  }>
                  {messenger.name} ({messenger.job})
                </Button>
              ))}
            </Stack>
            {!!canSpam && (
              <Button
                fluid
                mt={1}
                content="envoyer à tous..."
                onClick={() => act('PDA_sendEveryone')}
              />
            )}
          </Section>
        </Stack>
        {!owner && !isSilicon && <NoIDDimmer />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const MessageListScreen = (props, context) => {
  const { act, data } = useBackend(context);
  const { messages = [] } = data;
  return (
    <NtosWindow width={600} height={800}>
      <NtosWindow.Content scrollable>
        <Stack vertical>
          <Section fill>
            <Button
              icon="arrow-left"
              content="Retour"
              onClick={() => act('PDA_viewMessages')}
            />
            <Button
              icon="trash"
              content="supprimer les messages"
              onClick={() => act('PDA_clearMessages')}
            />
          </Section>
          {messages.map((message) => (
            <Stack vertical key={message} mt={1}>
              <Section textAlign="left">
                <Box italic opacity={0.5} mb={1}>
                  {message.outgoing ? '(SORTANT)' : '(ENTRANT)'}
                </Box>
                {message.outgoing ? (
                  <Box bold>{message.target_details}</Box>
                ) : (
                  <Button
                    transparent
                    content={message.name + ' (' + message.job + ')'}
                    onClick={() =>
                      act('PDA_sendMessage', {
                        name: message.name,
                        job: message.job,
                        ref: message.ref,
                      })
                    }
                  />
                )}
              </Section>
              <Section fill mt={-1}>
                <Box italic>{message.contents}</Box>
                {!!message.photo && (
                  <Box as="img" src={message.photo_path} mt={1} />
                )}
              </Section>
            </Stack>
          ))}
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
