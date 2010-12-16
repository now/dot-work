# contents: dot-work Makefile.
#
# Copyright © 2007,2008 Nikolai Weibull <now@bitwi.se>

.PHONY: all diff install install-registry

all: diff

empty :=
space := $(empty) $(empty)
shell_quote = $(subst $(space),\ ,$(1))

# 1: File
# 2: Target
# 3: Mode
define GROUP_template_file
GROUP_diff_target := $(2).diff
.PHONY diff: $$(GROUP_diff_target)
$$(GROUP_diff_target):
	@$$(DIFF) -u $(2) $(1) || true

install: $(2)
$(2): $(1)
	$$(INSTALL) -D --mode=$(if $(3),$(3),644) --preserve-timestamps $$< $$(call shell_quote,$$@)

endef

# 1: Files
# 2: Parent directory
# 3: Prefix to add
# 4: Prefix to strip
# 5: Mode
define GROUP_template
$(eval $(foreach file,$(1),$(call GROUP_template_file,$(file),$(2)/$(3)$(file:$(4)%=%),$(5))))
endef

DIFF = diff
INSTALL = install
REGEDIT = regedit -s

prefix = ~
userconfdir = $(prefix)

DOTFILES = \
	   hotkeys.ahk

$(eval $(call GROUP_template,$(DOTFILES),$(userconfdir),.))

LIBFILES = \
	   lib/autohotkey/digraphs.ahk

$(eval $(call GROUP_template,$(LIBFILES),~))

BINFILES = \
	   bin/start-vim-server.vbs

$(eval $(call GROUP_template,$(BINFILES),~,,,755))

SHAREFILES = \
	     share/icons/bak.ico \
	     share/icons/cmp.ico \
	     share/icons/joy.ico \
	     share/icons/ord.ico \
	     share/icons/tageditor-generic.ico \
	     share/icons/text-html.ico \
	     share/icons/text-x-generic.ico

$(eval $(call GROUP_template,$(SHAREFILES),~))

BINSHAREFILES = \
		share/themes/ClearLooks/ClearLooks.msstyles \
		share/themes/ClearLooks/Shell/Human/shellstyle.dll \
		share/themes/ClearLooks/Shell/NormalColor/shellstyle.dll

$(eval $(call GROUP_template,$(BINSHAREFILES),~,,,755))

APPDATAFILES = \
	       GHISLER/lsplugin.ini \
	       GHISLER/no.bar \
	       GHISLER/packers/rar/default.sfx \
	       GHISLER/packers/rar/wincon.sfx \
	       GHISLER/packers/rar/zip.sfx \
	       GHISLER/plugins/wcx/7zip/7zip.ini \
	       GHISLER/plugins/wfx/sftp/rc/wfx_sftp_cfg.xrc \
	       GHISLER/plugins/wlx/imagine/imagine.ini \
	       GHISLER/plugins/wlx/ttfview/text.pat \
	       GHISLER/tango.icl \
	       GHISLER/tcignore.txt \
	       GHISLER/totalcmd.ini \
	       GHISLER/usercmd.ini \
	       GHISLER/work.ini \
	       LiteStep/personal/hotkey.rc \
	       LiteStep/personal/jkey/vk104.txt \
	       LiteStep/personal/lsxcommand/.keep \
	       LiteStep/personal/personal.rc \
	       LiteStep/themes/themeselect.rc \
	       LiteStep/themes/now/theme.rc \
	       LiteStep/themes/now/config/base.rc \
	       LiteStep/themes/now/config/lsxcommand.rc \
	       LiteStep/themes/now/config/system_tray.rc \
	       LiteStep/themes/now/config/vwm.rc \

APPDATABINFILES = \
		  GHISLER/languages/wcmd_now.lng \
		  GHISLER/languages/wcmd_now.mnu \
		  GHISLER/packers/rar/rar.exe \
		  GHISLER/packers/rar/unrar.exe \
		  GHISLER/plugins/wcx/7zip/7zip.wcx \
		  GHISLER/plugins/wcx/iso/iso.wcx \
		  GHISLER/plugins/wcx/targzbz2/targzbz2.wcx \
		  GHISLER/plugins/wdx/dirsizecalc/dirsizecalc.wdx \
		  GHISLER/plugins/wdx/encoding/encoding.wdx \
		  GHISLER/plugins/wdx/unicodetest/unicodetest.wdx \
		  GHISLER/plugins/wfx/environment/environment.wfx \
		  GHISLER/plugins/wfx/registry/registry.wfx \
		  GHISLER/plugins/wfx/sftp/password_crypter.dll \
		  GHISLER/plugins/wfx/sftp/psftp.dll \
		  GHISLER/plugins/wfx/sftp/sftp.wfx \
		  GHISLER/plugins/wfx/sftp/wfx_sftp_cfg.dll \
		  GHISLER/plugins/wlx/gswlx/gswlx.wlx \
		  GHISLER/plugins/wlx/imagine/imagine.dll \
		  GHISLER/plugins/wlx/imagine/imagine.wcx \
		  GHISLER/plugins/wlx/imagine/imagine.wlx \
		  GHISLER/plugins/wlx/imagine/plugin/j2k.dll \
		  GHISLER/plugins/wlx/imagine/plugin/jbig.dll \
		  GHISLER/plugins/wlx/ttfview/ttfview.wlx \
		  GHISLER/tango_shell32.dll \
		  GHISLER/tools/copy-to-multiple-folders.vbs \
		  GHISLER/tools/execute-many.vbs \
		  GHISLER/tools/work/add-files-to-trados-workbench-dialog.vbs \
		  GHISLER/tools/work/isodraw-run-macro.vbs \
		  GHISLER/tools/work/open-in-tradobeindecs.vbs \
		  GHISLER/tools/work/open-in-tageditor-non-retardedly.vbs \
		  GHISLER/tools/work/open-in-workbench-non-retardedly.vbs \
		  GHISLER/tools/work/ttx2x.wsf


appdatadir = $(call shell_quote,$(shell cygpath -u "$(APPDATA)"))

$(eval $(call GROUP_template,$(APPDATAFILES),$(appdatadir)))
$(eval $(call GROUP_template,$(APPDATABINFILES),$(appdatadir),,,755))

APPDATAFILES = \
	       dialog-death.ini

$(eval $(call GROUP_template,$(APPDATAFILES),$(appdatadir)/Dialog\ Death))

STARTUPFILES = \
	       start-up/clipx.lnk \
	       start-up/firefox.lnk \
	       start-up/hotkeys.lnk \
	       start-up/itunes.lnk \
	       start-up/outlook.lnk \
	       start-up/sh.lnk \
	       start-up/totalcmd.lnk

startupdir = $(call shell_quote,$(shell cygpath -P))/Startup

$(eval $(call GROUP_template,$(STARTUPFILES),$(startupdir),,start-up/,755))

REGISTRYFILES = \
		registry/environment.reg \
		registry/file-type-joy.reg \
		registry/file-type-ord.reg \
		registry/map-caps-lock-to-left-control.reg \
		registry/open-in-tageditor-non-retardedly.reg \
		registry/open-in-workbench-non-retardedly.reg \
		registry/putty-sessions.reg \
		registry/tageditor.reg \
		registry/totalcmd.reg

install-registry:
	for r in $(REGISTRYFILES); do $(REGEDIT) "$$r"; done
