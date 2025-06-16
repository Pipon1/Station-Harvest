import { NtosWindow } from '../layouts';
import { useBackend } from '../backend';
import { Stack, Section, Box, Button, Input, Table, Tooltip, NoticeBox, Divider, RestrictedInput } from '../components';

type Data = {
  name: string;
  owner_token: string;
  money: number;
  transaction_list: Transactions[];
  wanted_token: string;
};

type Transactions = {
  adjusted_money: number;
  reason: string;
};
let name_to_token, money_to_send, token;

export const NtosPay = (props, context) => {
  return (
    <NtosWindow width={495} height={655}>
      <NtosWindow.Content>
        <NtosPayContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosPayContent = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { name } = data;

  if (!name) {
    return (
      <NoticeBox>
        Vous devez insérer votre carte d'identité dans la fente
        pour utiliser cette application.
      </NoticeBox>
    );
  }

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Introduction />
      </Stack.Item>
      <Stack.Item>
        <TransferSection />
      </Stack.Item>
      <Stack.Item grow>
        <TransactionHistory />
      </Stack.Item>
    </Stack>
  );
};

/** Displays the user's name and balance. */
const Introduction = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { name, owner_token, money } = data;
  return (
    <Section textAlign="center">
      <Table>
        <Table.Row>Bonjour, {name}.</Table.Row>
        <Table.Row>Votre token de paie est {owner_token}.</Table.Row>
        <Table.Row>
          Solde sur le compte : {money} credit{money === 1 ? '' : 's'}
        </Table.Row>
      </Table>
    </Section>
  );
};

/** Displays the transfer section. */
const TransferSection = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { money, wanted_token } = data;

  return (
    <Stack>
      <Stack.Item>
        <Section vertical title="Transférer de l'argent">
          <Box>
            <Tooltip
              content="Entrer le token du compte sur lequel vous voulez transférer des crédits."
              position="top">
              <Input
                placeholder="Paier le compte"
                width="190px"
                onChange={(e, value) => (token = value)}
              />
            </Tooltip>
          </Box>
          <Tooltip
            content="Entrer la quantité de crédit à transferer."
            position="top">
            <RestrictedInput
              width="83px"
              minValue={1}
              maxValue={money}
              onChange={(_, value) => (money_to_send = value)}
              value={1}
            />
          </Tooltip>
          <Button
            content="Transférer les crédits"
            onClick={() =>
              act('Transaction', {
                token: token,
                amount: money_to_send,
              })
            }
          />
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="Obtenir le token" width="270px" height="98px">
          <Box>
            <Input
              placeholder="Non complet du compte."
              width="190px"
              onChange={(e, value) => (name_to_token = value)}
            />
            <Button
              content="L'obtenir"
              onClick={() =>
                act('GetPayToken', {
                  wanted_name: name_to_token,
                })
              }
            />
          </Box>
          <Divider hidden />
          <Box nowrap>{wanted_token}</Box>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

/** Displays the transaction history. */
const TransactionHistory = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { transaction_list = [] } = data;

  return (
    <Section fill title="Historique des transactions">
      <Section fill scrollable title={<TableHeaders />}>
        <Table>
          {transaction_list.map((log) => (
            <Table.Row
              key={log}
              className="candystripe"
              color={log.adjusted_money < 1 ? 'red' : 'green'}>
              <Table.Cell width="100px">
                {log.adjusted_money > 1 ? '+' : ''}
                {log.adjusted_money}
              </Table.Cell>
              <Table.Cell textAlign="center">{log.reason}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Section>
  );
};

/** Renders a set of sticky headers */
const TableHeaders = (props, context) => {
  return (
    <Table>
      <Table.Row>
        <Table.Cell color="label" width="100px">
          Amount
        </Table.Cell>
        <Table.Cell color="label" textAlign="center">
          Reason
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};
