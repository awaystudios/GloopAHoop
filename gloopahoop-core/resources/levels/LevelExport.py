import bpy
from io_awd.awd_export import AWDExporter

blend = bpy.path.basename(bpy.context.blend_data.filepath)
name = blend.replace('.blend', '.awd')

path = bpy.path.abspath('//../../../bin/assets/levels/%s' % name)
exporter = AWDExporter()
exporter.export(bpy.context, filepath=path)