project('gtk-changes', 'vala', 'c')

gnome = import('gnome')

executable(
    meson.project_name(),
    'Application.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('granite', version: '>=0.5'),
        dependency('gtk+-3.0'),
    ]
)
