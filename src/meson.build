journaling_ui_sources = [
  'utils/PasswordManager.vala',
  'ui/window.vala',
  'ui/MainNavigation.vala',
  'ui'/ 'pages' / 'Home.vala',
  'ui'/ 'pages' / 'IncrementCount.vala',
  'ui'/ 'pages' / 'LockScreen.vala'
]

journaling_sources = [
  'main.vala',
  'application.vala',
  journaling_ui_sources
]

journaling_deps = [
  dependency('libsecret-1'),
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

journaling_sources += gnome.compile_resources(
  'journaling-resources',
  'journaling.gresource.xml',
  c_name: 'journaling',
)

executable('journaling', journaling_sources,
  dependencies: journaling_deps,
       install: true,
)
