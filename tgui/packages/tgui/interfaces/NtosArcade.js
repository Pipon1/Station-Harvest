import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Grid, LabeledList, ProgressBar, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosArcade = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <NtosWindow width={450} height={350}>
      <NtosWindow.Content>
        <Section title="Outbomb Cuban Pete Ultra" textAlign="center">
          <Box>
            <Grid>
              <Grid.Column size={2}>
                <Box m={1} />
                <LabeledList>
                  <LabeledList.Item label="Point de vie du joueur">
                    <ProgressBar
                      value={data.PlayerHitpoints}
                      minValue={0}
                      maxValue={30}
                      ranges={{
                        olive: [31, Infinity],
                        good: [20, 31],
                        average: [10, 20],
                        bad: [-Infinity, 10],
                      }}>
                      {data.PlayerHitpoints}HP
                    </ProgressBar>
                  </LabeledList.Item>
                  <LabeledList.Item label="Magie du joueur">
                    <ProgressBar
                      value={data.PlayerMP}
                      minValue={0}
                      maxValue={10}
                      ranges={{
                        purple: [11, Infinity],
                        violet: [3, 11],
                        bad: [-Infinity, 3],
                      }}>
                      {data.PlayerMP}MP
                    </ProgressBar>
                  </LabeledList.Item>
                </LabeledList>
                <Box my={1} mx={4} />
                <Section
                  backgroundColor={
                    data.PauseState === 1 ? '#1b3622' : '#471915'
                  }>
                  {data.Status}
                </Section>
              </Grid.Column>
              <Grid.Column>
                <ProgressBar
                  value={data.Hitpoints}
                  minValue={0}
                  maxValue={45}
                  ranges={{
                    good: [30, Infinity],
                    average: [5, 30],
                    bad: [-Infinity, 5],
                  }}>
                  <AnimatedNumber value={data.Hitpoints} />
                  HP
                </ProgressBar>
                <Box m={1} />
                <Section inline width="156px" textAlign="center">
                  <img src={resolveAsset(data.BossID)} />
                </Section>
              </Grid.Column>
            </Grid>
            <Box my={1} mx={4} />
            <Button
              icon="fist-raised"
              tooltip="Allez, tuez les !"
              tooltipPosition="top"
              disabled={data.GameActive === 0 || data.PauseState === 1}
              onClick={() => act('Attack')}
              content="Attaquez !"
            />
            <Button
              icon="band-aid"
              tooltip="Soignez-vous !"
              tooltipPosition="top"
              disabled={data.GameActive === 0 || data.PauseState === 1}
              onClick={() => act('Heal')}
              content="Soignez !"
            />
            <Button
              icon="magic"
              tooltip="Rechargez votre magie !"
              tooltipPosition="top"
              disabled={data.GameActive === 0 || data.PauseState === 1}
              onClick={() => act('Recharge_Power')}
              content="Rechargez !"
            />
          </Box>
          <Box>
            <Button
              icon="sync-alt"
              tooltip="Une partie de plus ne vous fera pas de mal."
              tooltipPosition="top"
              disabled={data.GameActive === 1}
              onClick={() => act('Start_Game')}
              content="Commencer la partie"
            />
            <Button
              icon="ticket-alt"
              tooltip="Donner le à votre arcade locale pour gagner des prix !"
              tooltipPosition="top"
              disabled={data.GameActive === 1}
              onClick={() => act('Dispense_Tickets')}
              content="Recevoir des tickets"
            />
          </Box>
          <Box color={data.TicketCount >= 1 ? 'good' : 'normal'}>
            Earned Tickets: {data.TicketCount}
          </Box>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
