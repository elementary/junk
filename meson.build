project('inspector', 'vala', 'c')

gnome = import('gnome')

resources = gnome.compile_resources(
    'resources', 'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

executable(
    meson.project_name(),
    resources,
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Views/ElementsView.vala',
    'src/Views/PropertiesView.vala',
    'src/Views/StylesView.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('gtk+-3.0')
    ]
)
