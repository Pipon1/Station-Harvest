/**
 * @file
 * @copyright 2022 raffclar
 * @license MIT
 */

import { NtosWindow } from '../layouts';
import { useBackend, useLocalState } from '../backend';
import { Box, Section, TextArea, MenuBar, Divider } from '../components';
import { Component, createRef, RefObject } from 'inferno';
import { createLogger } from '../logging';
import { Dialog, UnsavedChangesDialog } from '../components/Dialog';
import { DesignBrowser } from './Fabrication/DesignBrowser';

const logger = createLogger('NtosNotepad');

const DEFAULT_DOCUMENT_NAME = 'Sans-titre';

type PartiallyUnderlinedProps = {
  str: string;
  indexStart: number;
};

const PartiallyUnderlined = (props: PartiallyUnderlinedProps) => {
  const { str, indexStart } = props;
  const start = str.substring(0, indexStart);
  const underlined = str.substring(indexStart, indexStart + 1);
  const end = indexStart < str.length - 1 ? str.substring(indexStart + 1) : '';
  return (
    <>
      {start}
      <span style={{ 'text-decoration': 'underline' }}>{underlined}</span>
      {end}
    </>
  );
};

enum Dialogs {
  NONE = 0,
  UNSAVED_CHANGES = 1,
  OPEN = 2,
  ABOUT = 3,
}

type MenuBarProps = {
  onSave: () => void;
  onExit: () => void;
  onNewNote: () => void;
  onCutSelected: () => void;
  onCopySelected: () => void;
  onPasteSelected: () => void;
  onDeleteSelected: () => void;
  showStatusBar: boolean;
  setShowStatusBar: (boolean) => void;
  wordWrap: boolean;
  setWordWrap: (boolean) => void;
  aboutNotepadDialog: () => void;
};

const NtosNotepadMenuBar = (props: MenuBarProps, context) => {
  const {
    onSave,
    onExit,
    onNewNote,
    onCutSelected,
    onCopySelected,
    onPasteSelected,
    onDeleteSelected,
    setShowStatusBar,
    showStatusBar,
    wordWrap,
    setWordWrap,
    aboutNotepadDialog,
  } = props;
  const [openOnHover, setOpenOnHover] = useLocalState(
    context,
    'openOnHover',
    false
  );
  const [openMenuBar, setOpenMenuBar] = useLocalState<string | null>(
    context,
    'openMenuBar',
    null
  );
  const onMenuItemClick = (value) => {
    setOpenOnHover(false);
    setOpenMenuBar(null);
    switch (value) {
      case 'save':
        onSave();
        break;
      case 'exit':
        onExit();
        break;
      case 'new':
        onNewNote();
        break;
      case 'cut':
        onCutSelected();
        break;
      case 'copy':
        onCopySelected();
        break;
      case 'paste':
        onPasteSelected();
        break;
      case 'delete':
        onDeleteSelected();
        break;
      case 'statusBar':
        setShowStatusBar(!showStatusBar);
        break;
      case 'wordWrap':
        setWordWrap(!wordWrap);
        break;
      case 'aboutNotepad':
        aboutNotepadDialog();
        break;
    }
  };
  // Adds the key using the value
  const getMenuItemProps = (value: string, displayText: string) => {
    return {
      key: value,
      value,
      displayText,
      onClick: onMenuItemClick,
    };
  };
  const itemProps = {
    openOnHover,
    setOpenOnHover,
    openMenuBar,
    setOpenMenuBar,
  };

  return (
    <MenuBar>
      <MenuBar.Dropdown
        entry="file"
        openWidth="22rem"
        display={<PartiallyUnderlined str="Fichier" indexStart={0} />}
        {...itemProps}>
        <MenuBar.Dropdown.MenuItem {...getMenuItemProps('new', 'Nouveau')} />
        <MenuBar.Dropdown.MenuItem {...getMenuItemProps('save', 'Sauvegarder')} />
        <MenuBar.Dropdown.Separator key="firstSep" />
        <MenuBar.Dropdown.MenuItem {...getMenuItemProps('exit', 'Quitter...')} />
      </MenuBar.Dropdown>
      <MenuBar.Dropdown
        entry="edit"
        openWidth="22rem"
        display={<PartiallyUnderlined str="Editer" indexStart={0} />}
        {...itemProps}>
        <MenuBar.Dropdown.MenuItem {...getMenuItemProps('cut', 'Couper')} />
        <MenuBar.Dropdown.MenuItem {...getMenuItemProps('copy', 'Copier')} />
        <MenuBar.Dropdown.MenuItem {...getMenuItemProps('paste', 'Coller')} />
        <MenuBar.Dropdown.MenuItem {...getMenuItemProps('delete', 'Supprimer')} />
      </MenuBar.Dropdown>
      <MenuBar.Dropdown
        entry="format"
        openWidth="15rem"
        display={<PartiallyUnderlined str="Formater" indexStart={1} />}
        {...itemProps}>
        <MenuBar.Dropdown.MenuItemToggle
          checked={wordWrap}
          {...getMenuItemProps('wordWrap', 'Retour à la ligne')}
        />
      </MenuBar.Dropdown>
      <MenuBar.Dropdown
        entry="view"
        openWidth="15rem"
        display={<PartiallyUnderlined str="Voir" indexStart={0} />}
        {...itemProps}>
        <MenuBar.Dropdown.MenuItemToggle
          checked={showStatusBar}
          {...getMenuItemProps('statusBar', 'Bar de statut')}
        />
      </MenuBar.Dropdown>
      <MenuBar.Dropdown
        entry="help"
        openWidth="17rem"
        display={<PartiallyUnderlined str="Aide" indexStart={0} />}
        {...itemProps}>
        <MenuBar.Dropdown.MenuItem
          {...getMenuItemProps('aboutNotepad', 'A propos du bloc-note')}
        />
      </MenuBar.Dropdown>
    </MenuBar>
  );
};

interface StatusBarProps {
  statuses: Statuses;
}

const StatusBar = (props: StatusBarProps) => {
  const { statuses } = props;
  return (
    <Box className="NtosNotepad__StatusBar">
      <Box className="NtosNotepad__StatusBar__entry" minWidth="15rem">
        Ln {statuses.line}, Col {statuses.column}
      </Box>
      <Box className="NtosNotepad__StatusBar__entry" minWidth="5rem">
        100%
      </Box>
      <Box className="NtosNotepad__StatusBar__entry" minWidth="12rem">
        NtOS (LF)
      </Box>
      <Box className="NtosNotepad__StatusBar__entry" minWidth="12rem">
        UTF-8
      </Box>
    </Box>
  );
};

type Statuses = {
  line: number;
  column: number;
};

const getStatusCounts = (text: string, selectionStart: number): Statuses => {
  const lines = text.substr(0, selectionStart).split('\n');
  return {
    line: lines.length,
    column: lines[lines.length - 1].length + 1,
  };
};

const TEXTAREA_UPDATE_TRIGGERS = [
  'click',
  'input',
  'paste',
  'cut',
  'mousemove',
  'select',
  'selectstart',
  'keydown',
];

interface NotePadTextAreaProps {
  maintainFocus: boolean;
  text: string;
  wordWrap: boolean;
  setText: (string) => void;
  setStatuses: (statuses: Statuses) => void;
}

class NotePadTextArea extends Component<NotePadTextAreaProps> {
  innerRef: RefObject<HTMLTextAreaElement>;

  constructor(props) {
    super(props);
    this.innerRef = createRef();
  }

  handleEvent(event: Event) {
    const area = event.target as HTMLTextAreaElement;
    this.props.setStatuses(getStatusCounts(area.value, area.selectionStart));
  }

  onblur() {
    if (!this.innerRef.current) {
      return;
    }

    if (this.props.maintainFocus) {
      this.innerRef.current.focus();
      return false;
    }

    return true;
  }

  // eslint-disable-next-line react/no-deprecated
  componentDidMount() {
    const textarea = this.innerRef?.current;
    if (!textarea) {
      logger.error(
        'NotePadTextArea.render(): Textarea RefObject should not be null'
      );
      return;
    }

    // Javascript – execute when textarea caret is moved
    // https://stackoverflow.com/a/53999418/5613731
    TEXTAREA_UPDATE_TRIGGERS.forEach((trigger) =>
      textarea.addEventListener(trigger, this)
    );
    // Slight hack: Keep selection when textarea loses focus so menubar actions can be used (i.e. cut, delete)
    textarea.onblur = this.onblur.bind(this);
  }

  componentWillUnmount() {
    const textarea = this.innerRef?.current;
    if (!textarea) {
      logger.error(
        'NotePadTextArea.componentWillUnmount(): Textarea RefObject should not be null'
      );
      return;
    }
    TEXTAREA_UPDATE_TRIGGERS.forEach((trigger) =>
      textarea.removeEventListener(trigger, this)
    );
  }

  render() {
    const { text, setText, wordWrap } = this.props;

    return (
      <TextArea
        innerRef={this.innerRef}
        onInput={(_, value) => setText(value)}
        className={'NtosNotepad__textarea'}
        scroll
        nowrap={!wordWrap}
        value={text}
      />
    );
  }
}

type AboutDialogProps = {
  close: () => void;
  clientName: string;
};

const AboutDialog = (props: AboutDialogProps) => {
  const { close, clientName } = props;
  const paragraphStyle = { 'padding': '.5rem 1rem 0 2rem' };
  return (
    <Dialog title="About Notepad" onClose={close} width={'500px'}>
      <div className="Dialog__body">
        <span className="NtosNotepad__AboutDialog__logo">NtOS</span>
        <Divider />
        <Box className="NtosNotepad__AboutDialog__text">
          <span style={paragraphStyle}>Nanotrasen NtOS</span>
          <span style={paragraphStyle}>
            Version 7815696ecbf1c96e6894b779456d330e
          </span>
          <span style={paragraphStyle}>
            &copy; Corporation NT. Tout droit reservé.
          </span>
          <span style={{ 'padding': '3rem 1rem 3rem 2rem' }}>
            Le système d'operation NtOS et son interface utilisateur sont protégés
            pour un copyright au nom de Nanotrasen. Ce copyright est effectif dans
            tous les systèmes solaire y comprit celui de sol.
          </span>
          <span
            style={{
              'padding': '3rem 1rem 0.5rem 2rem',
              'max-width': '35rem',
            }}>
            Ce produit est licensié sous les termes de la Corporation NT à :
          </span>
          <span style={{ 'padding': '0 1rem 0 4rem' }}>{clientName}</span>
        </Box>
      </div>
      <div className="Dialog__footer">
        <Dialog.Button onClick={close}>Ok</Dialog.Button>
      </div>
    </Dialog>
  );
};

type NoteData = {
  note: string;
};
type RetryActionType = (retrying?: boolean) => void;

export const NtosNotepad = (props, context) => {
  const { act, data, config } = useBackend<NoteData>(context);
  const { note } = data;
  const [documentName, setDocumentName] = useLocalState<string>(
    context,
    'documentName',
    DEFAULT_DOCUMENT_NAME
  );
  const [originalText, setOriginalText] = useLocalState<string>(
    context,
    'originalText',
    note
  );
  console.log(note);
  const [text, setText] = useLocalState<string>(context, 'text', note);
  const [statuses, setStatuses] = useLocalState<Statuses>(context, 'statuses', {
    line: 0,
    column: 0,
  });
  const [activeDialog, setActiveDialog] = useLocalState<Dialogs>(
    context,
    'activeDialog',
    Dialogs.NONE
  );
  const [retryAction, setRetryAction] = useLocalState<RetryActionType | null>(
    context,
    'activeAction',
    null
  );
  const [showStatusBar, setShowStatusBar] = useLocalState<boolean>(
    context,
    'showStatusBar',
    true
  );
  const [wordWrap, setWordWrap] = useLocalState<boolean>(
    context,
    'wordWrap',
    true
  );
  const handleCloseDialog = () => setActiveDialog(Dialogs.NONE);
  const handleSave = (newDocumentName: string = documentName) => {
    logger.log(`Sauver le document en tant que : ${newDocumentName}`);
    act('UpdateNote', { newnote: text });
    setOriginalText(text);
    setDocumentName(newDocumentName);
    logger.log('Essayer De refaire la précédente action');
    setActiveDialog(Dialogs.NONE);

    // Retry the previous action now that we've saved. The previous action could be to
    // close the application, a new document being created or
    // an existing document being opened
    if (retryAction) {
      retryAction(true);
    }
    setRetryAction(null);
  };
  const ensureUnsavedChangesAreHandled = (
    action: () => void,
    retrying = false
  ): boolean => {
    // This is a guard function that throws up the "unsaved changes" dialog if the user is
    // attempting to do something that will make them lose data
    if (!retrying && originalText !== text) {
      logger.log('Unsaved changes. Asking client to save');
      setRetryAction(() => action);
      setActiveDialog(Dialogs.UNSAVED_CHANGES);
      return true;
    }

    return false;
  };
  const exit = (retrying = false) => {
    if (ensureUnsavedChangesAreHandled(exit, retrying)) {
      return;
    }
    logger.log('Exiting Notepad');
    act('PC_exit');
  };
  const newNote = (retrying = false) => {
    if (ensureUnsavedChangesAreHandled(newNote, retrying)) {
      return;
    }
    setOriginalText('');
    setText('');
    setDocumentName(DEFAULT_DOCUMENT_NAME);
  };
  const noSave = () => {
    logger.log('Discarding unsaved changes');
    setActiveDialog(Dialogs.NONE);
    if (retryAction) {
      retryAction(true);
    }
  };

  // MS Notepad displays an asterisk when there's unsaved changes
  const unsavedAsterisk = text !== originalText ? '*' : '';
  return (
    <NtosWindow
      title={`${unsavedAsterisk}${documentName} - Notepad`}
      width={840}
      height={900}>
      <NtosWindow.Content>
        <Box className="NtosNotepad__layout">
          <NtosNotepadMenuBar
            onSave={handleSave}
            onExit={exit}
            onNewNote={newNote}
            onCutSelected={() => document.execCommand('cut')}
            onCopySelected={() => document.execCommand('copy')}
            onPasteSelected={() => document.execCommand('paste')}
            onDeleteSelected={() => document.execCommand('delete')}
            showStatusBar={showStatusBar}
            setShowStatusBar={setShowStatusBar}
            wordWrap={wordWrap}
            setWordWrap={setWordWrap}
            aboutNotepadDialog={() => setActiveDialog(Dialogs.ABOUT)}
          />
          <Section fill>
            <NotePadTextArea
              maintainFocus={activeDialog === Dialogs.NONE}
              text={text}
              wordWrap={wordWrap}
              setText={setText}
              setStatuses={setStatuses}
            />
          </Section>
          {showStatusBar && <StatusBar statuses={statuses} />}
        </Box>
      </NtosWindow.Content>
      {activeDialog === Dialogs.UNSAVED_CHANGES && (
        <UnsavedChangesDialog
          documentName={documentName}
          onSave={handleSave}
          onClose={handleCloseDialog}
          onDiscard={noSave}
        />
      )}
      {activeDialog === Dialogs.ABOUT && (
        <AboutDialog close={handleCloseDialog} clientName={config.user.name} />
      )}
    </NtosWindow>
  );
};
