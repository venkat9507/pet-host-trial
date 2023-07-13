import 'package:hive/hive.dart';
import 'package:pet_adoption_app/models/pet_hive_data.dart';

class PetAdapter extends TypeAdapter<Pet> {
  @override
  Pet read(BinaryReader reader) {
    final id = reader.readString();
    final isAdopted = reader.readBool();
    return Pet(id,isAdopted);
  }

  @override
  void write(BinaryWriter writer, Pet pet) {
    writer.writeString(pet.id);
    writer.writeBool(pet.isAdopted);
  }

  @override
  int get typeId => 0;
}