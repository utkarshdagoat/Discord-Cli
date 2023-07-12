//You can get all the fields of the class

import 'dart:mirrors';

List<String> get_all_fields(Type cls) {
  List<String> fields = [];
  ClassMirror classMirror = reflectClass(cls);
  Iterable<VariableMirror> variableMirrors =
      classMirror.declarations.values.whereType<VariableMirror>();
  for (VariableMirror variableMirror in variableMirrors) {
    if (MirrorSystem.getName(variableMirror.simpleName)[0] != '_') {
      fields.add(MirrorSystem.getName(variableMirror.simpleName));
    }
  }
  return fields;
}
