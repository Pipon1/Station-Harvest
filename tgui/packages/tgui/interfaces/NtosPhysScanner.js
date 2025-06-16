import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';
import { Section, Box } from '../components';
import { sanitizeText } from '../sanitize';

export const NtosPhysScanner = (props, context) => {
  const { act, data } = useBackend(context);
  const { last_record } = data;
  const textHtml = {
    __html: sanitizeText(last_record),
  };
  return (
    <NtosWindow width={600} height={350}>
      <NtosWindow.Content scrollable>
        <Section>
          Appuyer sur quelque chose (clic droit) avec votre tablette pour
          utiliser le scanner physique.
        </Section>
        <Section>
          <Box bold>
            DERNIER ENREGISTREMENT
            <br />
            <br />
          </Box>
          <Box
            style={{ 'white-space': 'pre-line' }}
            dangerouslySetInnerHTML={textHtml}
          />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
