class SequenceModel {
  final Edge startEdge;
  final List<Transition> transitions;

  SequenceModel({this.startEdge, this.transitions});

  factory SequenceModel.fromJson(Map<String, dynamic> json) {
    return SequenceModel(
      startEdge: Edge.fromJson(json['startEdge']),
      transitions: List.from(json['transitions']).map((t) => Transition.fromJson(t)).toList(),
    );
  }
}

class Edge {
  final String name;
  final String abbreviation;

  Edge({this.name, this.abbreviation});

  factory Edge.fromJson(Map<String, dynamic> json) {
    return Edge(
      name: json['name'],
      abbreviation: json['abbreviation'],
    );
  }
}

class Transition {
  final Move move;
  final Edge entry;
  final Edge exit;

  Transition({this.move, this.entry, this.exit});

  factory Transition.fromJson(Map<String, dynamic> json) {
    return Transition(
      move: Move.fromJson(json['move']),
      entry: Edge.fromJson(json['entry']),
      exit: Edge.fromJson(json['exit']),
    );
  }
}

class Move {
  final String name;
  final String description;
  final String abbreviation;
  final String category;

  Move({this.name, this.description, this.abbreviation, this.category});

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      name: json['name'],
      description: json['description'],
      abbreviation: json['abbreviation'],
      category: json['category'],
    );
  }
}
