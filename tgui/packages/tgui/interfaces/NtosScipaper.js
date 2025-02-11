import { useBackend } from '../backend';
import { BlockQuote, Button, Collapsible, Dropdown, Input, LabeledList, Section, Stack, Tabs, Box, Table, NoticeBox, Tooltip, Icon } from '../components';
import { TableCell, TableRow } from '../components/Table';
import { NtosWindow } from '../layouts';

export const NtosScipaper = (props, context) => {
  return (
    <NtosWindow width={650} height={500}>
      <NtosWindow.Content scrollable>
        <NtosScipaperContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const PaperPublishing = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    title,
    author,
    etAlia,
    abstract,
    fileList = [],
    expList = [],
    allowedTiers = [],
    allowedPartners = [],
    gains,
    selectedFile,
    selectedExperiment,
    tier,
    selectedPartner,
    coopIndex,
    fundingIndex,
  } = data;
  return (
    <>
      <Section title="Formulaire de publication">
        <LabeledList grow>
          <LabeledList.Item label="Titre">
            <Input
              fluid
              value={title}
              onChange={(e, value) =>
                act('rewrite', {
                  title: value,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="Auteur principal">
            <Input
              fluid
              value={author}
              onChange={(e, value) =>
                act('rewrite', {
                  author: value,
                })
              }
            />
            <Button selected={etAlia} onClick={() => act('et_alia')}>
              {'Plusieurs auteurs'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Abstrait">
            <Input
              fluid
              value={abstract}
              onChange={(e, value) =>
                act('rewrite', {
                  abstract: value,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="Fichiers séléctionnés">
            <Stack>
              <Stack.Item>
                <Dropdown
                  width="35rem"
                  options={Object.keys(fileList)}
                  displayText={selectedFile ? selectedFile : '-'}
                  onSelected={(ordfile_name) =>
                    act('select_file', {
                      selected_uid: fileList[ordfile_name],
                    })
                  }
                />
              </Stack.Item>
              <Stack.Item align="center">
                <Tooltip
                  position="left"
                  content="Le fichier qui contient des données expérimentales pour notre article. Doit être présent dans le disque dur pour être accessible. Transférez les fichiers avec le programme Gestionnaire de fichiers.">
                  <Icon size={1.15} name="info-circle" />
                </Tooltip>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="Equipement séléctionné">
            <Stack>
              <Stack.Item>
                <Dropdown
                  width="35rem"
                  options={Object.keys(expList)}
                  displayText={selectedExperiment ? selectedExperiment : '-'}
                  onSelected={(experiment_name) =>
                    act('select_experiment', {
                      selected_expath: expList[experiment_name],
                    })
                  }
                />
              </Stack.Item>
              <Stack.Item align="center">
                <Tooltip
                  position="left"
                  content="Le sujet sur lequel nous voulons publier notre article. Différents sujets débloquent différentes technologies et partenaires possibles.">
                  <Icon size={1.15} name="info-circle" />
                </Tooltip>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="Niveaux séléctionnés">
            <Stack>
              <Stack.Item>
                <Dropdown
                  width="35rem"
                  options={allowedTiers.map((number) => String(number))}
                  displayText={tier ? String(tier) : '-'}
                  onSelected={(new_tier) =>
                    act('select_tier', {
                      selected_tier: Number(new_tier),
                    })
                  }
                />
              </Stack.Item>
              <Stack.Item align="center">
                <Tooltip
                  position="left"
                  content="Le niveau sur lequel nous voulons publier. Les niveaux plus élevés peuvent conférer de meilleures récompenses, mais signifie que nos données seront jugées plus sévèrement.">
                  <Icon size={1.15} name="info-circle" />
                </Tooltip>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="Partenaires séléctionnés">
            <Stack>
              <Stack.Item>
                <Dropdown
                  width="35rem"
                  options={Object.keys(allowedPartners)}
                  displayText={selectedPartner ? selectedPartner : '-'}
                  onSelected={(new_partner) =>
                    act('select_partner', {
                      selected_partner: allowedPartners[new_partner],
                    })
                  }
                />
              </Stack.Item>
              <Stack.Item align="center">
                <Tooltip
                  position="left"
                  content="Les organisations avec lesquelles nous pouvons collaborer. Nous pouvons obtenir des boosts de recherche dans les technologies liées aux intérêts du partenaire.">
                  <Icon size={1.15} name="info-circle" />
                </Tooltip>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Résultats attendu" key="rewards">
        <Stack fill>
          <Stack.Item grow>
            <Tooltip
              position="top"
              content="De combien notre relation s'améliorera-t-elle avec le partenaire. La coopération sera utilisée pour débloquer des boosts.">
              <Icon size={1.15} name="info-circle" />
            </Tooltip>
            {' Coopération: '}
            <BlockQuote>{gains[coopIndex - 1]}</BlockQuote>
          </Stack.Item>
          <Stack.Item grow>
            <Tooltip
              position="top"
              content="De combien le don sera-t-il à la sortie de l'article.">
              <Icon size={1.15} name="info-circle" />
            </Tooltip>
            {' Donnation : '}
            <BlockQuote>{gains[fundingIndex - 1]}</BlockQuote>
          </Stack.Item>
        </Stack>
        <br />
        <Button
          icon="upload"
          textAlign="center"
          fluid
          onClick={() => act('publish')}
          content="Publier l'article"
        />
      </Section>
    </>
  );
};

const PaperBrowser = (props, context) => {
  const { act, data } = useBackend(context);
  const { publishedPapers, coopIndex, fundingIndex } = data;
  if (publishedPapers.length === 0) {
    return <NoticeBox> No Published Papers! </NoticeBox>;
  } else {
    return publishedPapers.map((paper) => (
      <Collapsible
        key={String(paper['experimentName'] + paper['tier'])}
        title={paper['title']}>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Sujet">
              {paper['experimentName'] + ' - ' + paper['tier']}
            </LabeledList.Item>
            <LabeledList.Item label="Auteur">
              {paper['author'] + (paper.etAlia ? ' et al.' : '')}
            </LabeledList.Item>
            <LabeledList.Item label="Partenaire">
              {paper['partner']}
            </LabeledList.Item>
            <LabeledList.Item label="Résultat">
              <LabeledList>
                <LabeledList.Item label="Coopération">
                  {paper['gains'][coopIndex - 1]}
                </LabeledList.Item>
                <LabeledList.Item label="Dons">
                  {paper['gains'][fundingIndex - 1]}
                </LabeledList.Item>
              </LabeledList>
            </LabeledList.Item>
            <LabeledList.Item label="Abstrait">
              {paper['abstract']}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Collapsible>
    ));
  }
};
const ExperimentBrowser = (props, context) => {
  const { act, data } = useBackend(context);
  const { experimentInformation = [] } = data;
  return experimentInformation.map((experiment) => (
    <Section title={experiment.name} key={experiment.name}>
      {experiment.description}
      <br />
      <LabeledList>
        {Object.keys(experiment.target).map((tier) => (
          <LabeledList.Item
            key={tier}
            label={
              'Optimal ' +
              experiment.prefix +
              ' Amount - Tier ' +
              String(Number(tier) + 1)
            }>
            {experiment.target[tier] + ' ' + experiment.suffix}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  ));
};

const PartnersBrowser = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    partnersInformation,
    coopIndex,
    fundingIndex,
    purchaseableBoosts = [],
    relations = [],
    visibleNodes = [],
  } = data;
  return partnersInformation.map((partner) => (
    <Section title={partner.name} key={partner.path}>
      <Collapsible title={'Relations : ' + relations[partner.path]}>
        <LabeledList>
          <LabeledList.Item label="Description">
            {partner.flufftext}
          </LabeledList.Item>
          <LabeledList.Item label="Relations">
            {relations[partner.path]}
          </LabeledList.Item>
          <LabeledList.Item label="Bonus de coopération">
            {partner.multipliers[coopIndex - 1] + 'x'}
          </LabeledList.Item>
          <LabeledList.Item label="Bonus de dons">
            {partner.multipliers[fundingIndex - 1] + 'x'}
          </LabeledList.Item>
          <LabeledList.Item label="Expériences acceptées">
            {partner.acceptedExperiments.map((experiment_name) => (
              <Box key={experiment_name}>{experiment_name}</Box>
            ))}
          </LabeledList.Item>
          <LabeledList.Item label="Partage de technologie">
            <Table>
              {partner.boostedNodes.map((node) => (
                <TableRow key={node.id}>
                  <TableCell>
                    {visibleNodes.includes(node.id)
                      ? node.name
                      : 'Technologie inconnue'}
                  </TableCell>
                  <TableCell>
                    <Button
                      fluid
                      tooltipPosition="left"
                      textAlign="center"
                      disabled={
                        !purchaseableBoosts[partner.path].includes(node.id)
                      }
                      content="Acheter"
                      tooltip={'Réduction : ' + node.discount}
                      onClick={() =>
                        act('purchase_boost', {
                          purchased_boost: node.id,
                          boost_seller: partner.path,
                        })
                      }
                    />
                  </TableCell>
                </TableRow>
              ))}
            </Table>
          </LabeledList.Item>
        </LabeledList>
      </Collapsible>
    </Section>
  ));
};

export const NtosScipaperContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { currentTab, has_techweb } = data;
  return (
    <>
      {!has_techweb && (
        <Section title="Aucune connexion !" key="rewards">
          S'il vous plaît, connectez-vous à un Techweb valide pour télécharger !
        </Section>
      )}
      <Tabs key="navigation">
        <Tabs.Tab
          selected={currentTab === 1}
          onClick={() =>
            act('change_tab', {
              new_tab: 1,
            })
          }>
          {'Publier l\'article'}
        </Tabs.Tab>
        <Tabs.Tab
          selected={currentTab === 2}
          onClick={() =>
            act('change_tab', {
              new_tab: 2,
            })
          }>
          {'Voir les publications précédentes'}
        </Tabs.Tab>
        <Tabs.Tab
          selected={currentTab === 3}
          onClick={() =>
            act('change_tab', {
              new_tab: 3,
            })
          }>
          {'Voir les expériences disponibles'}
        </Tabs.Tab>
        <Tabs.Tab
          selected={currentTab === 4}
          onClick={() =>
            act('change_tab', {
              new_tab: 4,
            })
          }>
          {'Voir les partenaires disponibles'}
        </Tabs.Tab>
      </Tabs>
      {currentTab === 1 && <PaperPublishing />}
      {currentTab === 2 && <PaperBrowser />}
      {currentTab === 3 && <ExperimentBrowser />}
      {currentTab === 4 && <PartnersBrowser />}
    </>
  );
};
