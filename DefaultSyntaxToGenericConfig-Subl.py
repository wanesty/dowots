import sublime, sublime_plugin

class NewFileSyntax(sublime_plugin.EventListener):
  def on_new(self, view):
    view.set_syntax_file('GenericConfig.sublime-syntax')


class UknOpenFile(sublime_plugin.EventListener):
    def on_load(self, view):
        self.check_syntax(view)

    def on_activated(self, view):
        self.check_syntax(view)

    def check_syntax(self, view):
        file_name = view.file_name()
        if view.settings().get('syntax') == 'Packages/Text/Plain text.tmLanguage' and not file_name.endswith('.txt'):
            view.set_syntax_file('GenericConfig.sublime-syntax')
