import { scale, toFixed } from 'common/math';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Stack, Icon, LabeledList, NoticeBox, ProgressBar, Section, Tabs } from '../components';
import { flow } from 'common/fp';
import { filter, sortBy } from 'common/collections';
import { NtosWindow } from '../layouts';

export const NtosNetDownloader = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    PC_device_theme,
    disk_size,
    disk_used,
    downloadcompletion,
    downloading,
    downloadname,
    downloadsize,
    error,
    emagged,
    categories,
    programs,
  } = data;
  const all_categories = ['Tous'].concat(categories);
  const downloadpercentage = toFixed(
    scale(downloadcompletion, 0, downloadsize) * 100
  );
  const [selectedCategory, setSelectedCategory] = useLocalState(
    context,
    'category',
    all_categories[0]
  );
  const items = flow([
    // This filters the list to only contain programs with category
    selectedCategory !== all_categories[0] &&
      filter((program) => program.category === selectedCategory),
    // This filters the list to only contain verified programs
    !emagged &&
      PC_device_theme !== 'syndicate' &&
      filter((program) => program.verifiedsource === 1),
    // This sorts all programs in the lists by name and compatibility
    sortBy(
      (program) => -program.compatible,
      (program) => program.filedesc
    ),
  ])(programs);
  const disk_free_space = downloading
    ? disk_size - toFixed(disk_used + downloadcompletion)
    : disk_size - disk_used;
  return (
    <NtosWindow width={600} height={600}>
      <NtosWindow.Content scrollable>
        {!!error && (
          <NoticeBox>
            <Box mb={1}>{error}</Box>
            <Button content="Redémarrer" onClick={() => act('PRG_reseterror')} />
          </NoticeBox>
        )}
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="Disque dur"
              buttons={
                (!!downloading && (
                  <Button
                    icon="spinner"
                    iconSpin={1}
                    tooltipPosition="left"
                    tooltip={
                      !!downloading &&
                      `Téléchargement : ${downloadname}.prg (${downloadpercentage}%)`
                    }
                  />
                )) ||
                (!!downloadname && (
                  <Button
                    color="good"
                    icon="download"
                    tooltipPosition="left"
                    tooltip={`${downloadname}.prg téléchargé`}
                  />
                ))
              }>
              <ProgressBar
                value={downloading ? disk_used + downloadcompletion : disk_used}
                minValue={0}
                maxValue={disk_size}>
                <Box textAlign="left">
                  {`${disk_free_space} GQ libre sur ${disk_size} GQ`}
                </Box>
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Stack>
          <Stack.Item minWidth="105px" shrink={0} basis={0}>
            <Tabs vertical>
              {all_categories.map((category) => (
                <Tabs.Tab
                  key={category}
                  selected={category === selectedCategory}
                  onClick={() => setSelectedCategory(category)}>
                  {category}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow={1} basis={0}>
            {items?.map((program) => (
              <Program key={program.filename} program={program} />
            ))}
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const Program = (props, context) => {
  const { program } = props;
  const { act, data } = useBackend(context);
  const {
    PC_device_theme,
    disk_size,
    disk_used,
    downloading,
    downloadname,
    downloadcompletion,
  } = data;
  const disk_free = disk_size - disk_used;
  return (
    <Section>
      <Stack align="baseline">
        <Stack.Item grow={1} blod>
          <Icon name={program.icon} mr={1} />
          {program.filedesc}
        </Stack.Item>
        <Stack.Item
          shrink={0}
          width="48px"
          textAlign="right"
          color="label"
          nowrap>
          {program.size} GQ
        </Stack.Item>
        <Stack.Item shrink={0} width="134px" textAlign="right">
          {(downloading && program.filename === downloadname && (
            <ProgressBar
              width="101px"
              height="23px"
              color="good"
              minValue={0}
              maxValue={program.size}
              value={downloadcompletion}
            />
          )) ||
            (!program.installed &&
              program.compatible &&
              program.access &&
              program.size < disk_free && (
                <Button
                  bold
                  icon="download"
                  content="Télécharger"
                  disabled={downloading}
                  tooltipPosition="left"
                  tooltip={!!downloading && 'En attente de la fin du téléchargement...'}
                  onClick={() =>
                    act('PRG_downloadfile', {
                      filename: program.filename,
                    })
                  }
                />
              )) || (
              <Button
                bold
                icon={program.installed ? 'check' : 'times'}
                color={
                  program.installed
                    ? 'good'
                    : !program.compatible
                      ? 'bad'
                      : 'grey'
                }
                content={
                  program.installed
                    ? 'Installé'
                    : !program.compatible
                      ? 'Incompatible'
                      : !program.access
                        ? 'Accès interdit'
                        : 'Pas assez de place'
                }
              />
            )}
        </Stack.Item>
      </Stack>
      <Box mt={1} italic color="label">
        {program.fileinfo}
      </Box>
      {!program.verifiedsource && PC_device_theme !== 'syndicate' && (
        <NoticeBox mt={1} mb={0} danger fontSize="12px">
          Source inconnu. Veuillez noter que Nanotrasen ne recommande pas le
          téléchargement et l'utilisation de logiciels provenant de serveurs non-officiel.
        </NoticeBox>
      )}
    </Section>
  );
};
