const String CLOCKWISE_PREFERENCE = 'clockwise';
const String LEVEL_PREFERENCE = 'level';
// TODO: These should probably come from server eventually
class Level {
  const Level({this.abbreviation, this.name});
  final String abbreviation;
  final String name;
}
const List<Level> levels = [
  const Level(abbreviation: 'AB', name: 'Bronze'),
  const Level(abbreviation: 'AS', name: 'Silver'),
  const Level(abbreviation: 'AG', name: 'Gold'),
];
