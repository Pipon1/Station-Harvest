import { useBackend, useSharedState } from '../backend';
import { Box, Button, Dropdown, LabeledList, ProgressBar, Section, Stack, Tabs } from '../components';
import { NtosWindow } from '../layouts';

const getMuleByRef = (mules, ref) => {
  return mules?.find((mule) => mule.mule_ref === ref);
};

export const NtosRoboControl = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab_main, setTab_main] = useSharedState(context, 'tab_main', 1);
  const { bots, drones, id_owner, droneaccess, dronepingtypes } = data;
  return (
    <NtosWindow width={550} height={550}>
      <NtosWindow.Content scrollable>
        <Section title="Ordinateur de controle des robots">
          <LabeledList>
            <LabeledList.Item label="ID">{id_owner}</LabeledList.Item>
            <LabeledList.Item label="Robots atteignable">
              {data.botcount}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Stack.Item>
          <Tabs>
            <Tabs.Tab
              icon="robot"
              lineHeight="23px"
              selected={tab_main === 1}
              onClick={() => setTab_main(1)}>
              Robots
            </Tabs.Tab>
            <Tabs.Tab
              icon="hammer"
              lineHeight="23px"
              selected={tab_main === 2}
              onClick={() => setTab_main(2)}>
              Drones
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        {tab_main === 1 && (
          <Stack.Item>
            <Section>
              <LabeledList>
                <LabeledList.Item label="Robots atteignable">
                  {data.botcount}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            {bots?.map((robot) => (
              <RobotInfo key={robot.bot_ref} robot={robot} />
            ))}
          </Stack.Item>
        )}
        {tab_main === 2 && (
          <Stack.Item grow>
            <Section>
              <Button
                icon="address-card"
                tooltip="Donne/Retire l'accès aux drones pour interagir avec les machines et les câbles qui seraient autrement considérés comme dangereux."
                content={
                  droneaccess ? 'Donne l\'accès au drone' : 'Retire l\'accès au drone'
                }
                color={droneaccess ? 'good' : 'bad'}
                onClick={() => act('changedroneaccess')}
              />
              <Dropdown
                tooltip="Afficher la positions des drones"
                width="100%"
                displayText={'Drone pings'}
                options={dronepingtypes}
                onSelected={(value) => act('ping_drones', { ping_type: value })}
              />
            </Section>
            {drones?.map((drone) => (
              <DroneInfo key={drone.drone_ref} drone={drone} />
            ))}
          </Stack.Item>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const RobotInfo = (props, context) => {
  const { robot } = props;
  const { act, data } = useBackend(context);
  const mules = data.mules || [];
  // Get a mule object
  const mule = !!robot.mule_check && getMuleByRef(mules, robot.bot_ref);
  // Color based on type of a robot
  const color =
    robot.mule_check === 1 ? 'rgba(110, 75, 14, 1)' : 'rgba(74, 59, 140, 1)';
  return (
    <Section
      title={robot.name}
      style={{
        border: `4px solid ${color}`,
      }}
      buttons={
        mule && (
          <>
            <Button
              icon="play"
              tooltip="Aller à la destination."
              onClick={() =>
                act('go', {
                  robot: mule.mule_ref,
                })
              }
            />
            <Button
              icon="pause"
              tooltip="Arrêter de bouger."
              onClick={() =>
                act('stop', {
                  robot: mule.mule_ref,
                })
              }
            />
            <Button
              icon="home"
              tooltip="Revenir au point de départ."
              tooltipPosition="bottom-start"
              onClick={() =>
                act('home', {
                  robot: mule.mule_ref,
                })
              }
            />
          </>
        )
      }>
      <Stack>
        <Stack.Item grow={1} basis={0}>
          <LabeledList>
            <LabeledList.Item label="Modèle">{robot.model}</LabeledList.Item>
            <LabeledList.Item label="Position">{robot.locat}</LabeledList.Item>
            <LabeledList.Item label="Statut">{robot.mode}</LabeledList.Item>
            {mule && (
              <>
                <LabeledList.Item label="Cargo chargé">
                  {data.load || 'N/A'}
                </LabeledList.Item>
                <LabeledList.Item label="Point de départ">{mule.home}</LabeledList.Item>
                <LabeledList.Item label="Destination">
                  {mule.dest || 'N/A'}
                </LabeledList.Item>
                <LabeledList.Item label="Charge">
                  <ProgressBar
                    value={mule.power}
                    minValue={0}
                    maxValue={100}
                    ranges={{
                      good: [60, Infinity],
                      average: [20, 60],
                      bad: [-Infinity, 20],
                    }}
                  />
                </LabeledList.Item>
              </>
            )}
          </LabeledList>
        </Stack.Item>
        <Stack.Item width="150px">
          {mule && (
            <>
              <Button
                fluid
                content="Définir la destination"
                onClick={() =>
                  act('destination', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button
                fluid
                content="Définir l'ID"
                onClick={() =>
                  act('setid', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button
                fluid
                content="Définir le point de départ"
                onClick={() =>
                  act('sethome', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button
                fluid
                content="Décharger le cargo"
                onClick={() =>
                  act('unload', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button.Checkbox
                fluid
                content="Retour automatique"
                checked={mule.autoReturn}
                onClick={() =>
                  act('autoret', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button.Checkbox
                fluid
                content="Ramassage automatique"
                checked={mule.autoPickup}
                onClick={() =>
                  act('autopick', {
                    robot: mule.mule_ref,
                  })
                }
              />
              <Button.Checkbox
                fluid
                content="Rapport de livraison"
                checked={mule.reportDelivery}
                onClick={() =>
                  act('report', {
                    robot: mule.mule_ref,
                  })
                }
              />
            </>
          )}
          {!mule && (
            <>
              <Button
                fluid
                content="Arrêter la patrouille"
                onClick={() =>
                  act('patroloff', {
                    robot: robot.bot_ref,
                  })
                }
              />
              <Button
                fluid
                content="Commencer la patrouille"
                onClick={() =>
                  act('patrolon', {
                    robot: robot.bot_ref,
                  })
                }
              />
              <Button
                fluid
                content="Appeller le robot"
                onClick={() =>
                  act('summon', {
                    robot: robot.bot_ref,
                  })
                }
              />
              <Button
                fluid
                content="Ejecter le IAp"
                onClick={() =>
                  act('ejectpai', {
                    robot: robot.bot_ref,
                  })
                }
              />
            </>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const DroneInfo = (props, context) => {
  const { drone } = props;
  const { act, data } = useBackend(context);
  const color = 'rgba(74, 59, 140, 1)';

  return (
    <Section
      title={drone.name}
      style={{
        border: `4px solid ${color}`,
      }}>
      <Stack>
        <Stack.Item grow={1} basis={0}>
          <LabeledList>
            <LabeledList.Item label="Statut">
              <Box color={drone.status ? 'bad' : 'good'}>
                {drone.status ? 'Hors ligne' : 'En ligne'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
