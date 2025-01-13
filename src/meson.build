journaling_ui_sources = [
  'utils' / 'test.vala',
  'utils' / 'PasswordManager.vala',
  'window.vala',
  'MainNavigation.vala',
  'pages' / 'Home.vala',
  'pages' / 'IncrementCount.vala',
  'pages' / 'LockScreen.vala'
]

journaling_sources = [
  'main.vala',
  'application.vala',
  journaling_ui_sources
]

journaling_deps = [
  dependency('libsecret-1'),
  dependency('gtk4'),
  dependency('vui'),
  dependency('libadwaita-1', version: '>= 1.5'),
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
