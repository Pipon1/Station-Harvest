import { useBackend, useSharedState } from '../backend';
import { AnimatedNumber, Box, Button, Flex, LabeledList, ProgressBar, Section, Slider, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export const NtosRobotact = (props, context) => {
  return (
    <NtosWindow width={800} height={600}>
      <NtosWindow.Content>
        <NtosRobotactContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosRobotactContent = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab_main, setTab_main] = useSharedState(context, 'tab_main', 1);
  const [tab_sub, setTab_sub] = useSharedState(context, 'tab_sub', 1);
  const {
    charge,
    maxcharge,
    integrity,
    lampIntensity,
    cover,
    locomotion,
    wireModule,
    wireCamera,
    wireAI,
    wireLaw,
    sensors,
    printerPictures,
    printerToner,
    printerTonerMax,
    thrustersInstalled,
    thrustersStatus,
    selfDestructAble,
  } = data;
  const borgName = data.name || [];
  const borgType = data.designation || [];
  const masterAI = data.masterAI || [];
  const laws = data.Laws || [];
  const borgLog = data.borgLog || [];
  const borgUpgrades = data.borgUpgrades || [];
  return (
    <Flex direction={'column'}>
      <Flex.Item position="relative" mb={1}>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 1}
            onClick={() => setTab_main(1)}>
            Statut
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 2}
            onClick={() => setTab_main(2)}>
            Logs
          </Tabs.Tab>
        </Tabs>
      </Flex.Item>
      {tab_main === 1 && (
        <>
          <Flex direction={'row'}>
            <Flex.Item width="30%">
              <Section title="Configuration" fill>
                <LabeledList>
                  <LabeledList.Item label="Unité">
                    {borgName.slice(0, 17)}
                  </LabeledList.Item>
                  <LabeledList.Item label="Type">{borgType}</LabeledList.Item>
                  <LabeledList.Item label="IA">
                    {masterAI.slice(0, 17)}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Flex.Item>
            <Flex.Item grow={1} basis="content" ml={1}>
              <Section title="Statut">
                Charge :
                <Button
                  content="Alerte de charge"
                  disabled={charge}
                  onClick={() => act('alertPower')}
                />
                <ProgressBar
                  value={charge / maxcharge}
                  ranges={{
                    good: [0.5, Infinity],
                    average: [0.1, 0.5],
                    bad: [-Infinity, 0.1],
                  }}>
                  <AnimatedNumber value={charge} />
                </ProgressBar>
                Intégrité du chassis :
                <ProgressBar
                  value={integrity}
                  minValue={0}
                  maxValue={100}
                  ranges={{
                    bad: [-Infinity, 25],
                    average: [25, 75],
                    good: [75, Infinity],
                  }}
                />
              </Section>
              <Section title="Puissance de la lampe">
                <Slider
                  value={lampIntensity}
                  step={1}
                  stepPixelSize={25}
                  maxValue={5}
                  minValue={1}
                  onChange={(e, value) =>
                    act('lampIntensity', {
                      ref: value,
                    })
                  }
                />
                Utilisation de charche de la lampe : {lampIntensity / 2} watts
              </Section>
            </Flex.Item>
            <Flex.Item width="50%" ml={1}>
              <Section fitted>
                <Tabs fluid={1} textAlign="center">
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 1}
                    onClick={() => setTab_sub(1)}>
                    Actions
                  </Tabs.Tab>
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 2}
                    onClick={() => setTab_sub(2)}>
                    Améliorations
                  </Tabs.Tab>
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 3}
                    onClick={() => setTab_sub(3)}>
                    Diagnostiques
                  </Tabs.Tab>
                </Tabs>
              </Section>
              {tab_sub === 1 && (
                <Section>
                  <LabeledList>
                    <LabeledList.Item label="Trappe de maintenance">
                      <Button.Confirm
                        content="Dévérouiller"
                        disabled={cover === 'UNLOCKED'}
                        onClick={() => act('coverunlock')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Système de senseurs">
                      <Button
                        content={sensors}
                        onClick={() => act('toggleSensors')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item
                      label={'Photos sauvegardé (' + printerPictures + ')'}>
                      <Button
                        content="Voir"
                        disabled={!printerPictures}
                        onClick={() => act('viewImage')}
                      />
                      <Button
                        content="Imprimer"
                        disabled={!printerPictures}
                        onClick={() => act('printImage')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Toner de l'imprimante">
                      <ProgressBar value={printerToner / printerTonerMax} />
                    </LabeledList.Item>
                    {!!thrustersInstalled && (
                      <LabeledList.Item label="Allumer les réacteurs">
                        <Button
                          content={thrustersStatus}
                          onClick={() => act('toggleThrusters')}
                        />
                      </LabeledList.Item>
                    )}
                    {!!selfDestructAble && (
                      <LabeledList.Item label="Auto-déstruction">
                        <Button.Confirm
                          content="ACTIVATER"
                          color="red"
                          onClick={() => act('selfDestruct')}
                        />
                      </LabeledList.Item>
                    )}
                  </LabeledList>
                </Section>
              )}
              {tab_sub === 2 && (
                <Section>
                  {borgUpgrades.map((upgrade) => (
                    <Box mb={1} key={upgrade}>
                      {upgrade}
                    </Box>
                  ))}
                </Section>
              )}
              {tab_sub === 3 && (
                <Section>
                  <LabeledList>
                    <LabeledList.Item
                      label="Connexion de l'IA"
                      color={
                        wireAI === 'FAULT'
                          ? 'red'
                          : wireAI === 'READY'
                            ? 'yellow'
                            : 'green'
                      }>
                      {wireAI}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="LoiCon"
                      color={wireLaw === 'FAULT' ? 'red' : 'green'}>
                      {wireLaw}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Caméra"
                      color={
                        wireCamera === 'FAULT'
                          ? 'red'
                          : wireCamera === 'DISABLED'
                            ? 'yellow'
                            : 'green'
                      }>
                      {wireCamera}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Module controlleur"
                      color={wireModule === 'FAULT' ? 'red' : 'green'}>
                      {wireModule}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Moteur controlleur"
                      color={
                        locomotion === 'FAULT'
                          ? 'red'
                          : locomotion === 'DISABLED'
                            ? 'yellow'
                            : 'green'
                      }>
                      {locomotion}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Trappe de maintenance"
                      color={cover === 'UNLOCKED' ? 'red' : 'green'}>
                      {cover}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              )}
            </Flex.Item>
          </Flex>
          <Flex.Item height={21} mt={1}>
            <Section
              title="Lois"
              fill
              scrollable
              buttons={
                <>
                  <Button
                    content="Afficher ses lois"
                    onClick={() => act('lawstate')}
                  />
                  <Button icon="volume-off" onClick={() => act('lawchannel')} />
                </>
              }>
              {laws.map((law) => (
                <Box mb={1} key={law}>
                  {law}
                </Box>
              ))}
            </Section>
          </Flex.Item>
        </>
      )}
      {tab_main === 2 && (
        <Flex.Item height={40}>
          <Section fill scrollable backgroundColor="black">
            {borgLog.map((log) => (
              <Box mb={1} key={log}>
                <font color="green">{log}</font>
              </Box>
            ))}
          </Section>
        </Flex.Item>
      )}
    </Flex>
  );
};
