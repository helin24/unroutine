import 'dart:convert';

class SequenceModel {
  final Edge startEdge;
  final List<Transition> transitions;
  final String name;
  final DateTime savedOn;
  final String audioUrl;
  final int id;

  SequenceModel({
    this.startEdge,
    this.transitions,
    this.name,
    this.savedOn,
    this.audioUrl,
    this.id,
  });

  factory SequenceModel.fromJson(Map<String, dynamic> json) {
    return SequenceModel(
      name: json['name'],
      startEdge: Edge.fromJson(json['startEdge']),
      transitions: List.from(json['transitions'])
          .map((t) => Transition.fromJson(t))
          .toList(),
      savedOn: json['savedOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['savedOn'] * 1000).round())
          : null,
      audioUrl: json['audioUrl'] != null ? json['audioUrl'] : null,
      id: json['id'] != null ? json['id'] : null,
    );
  }

  Map<String, dynamic> toDatabaseMap() {
    DateTime now = DateTime.now();
    return {
      'name': 'Saved ' + now.toIso8601String(),
      'startEdge': jsonEncode(startEdge),
      'transitions': jsonEncode(transitions),
      'savedOn': now.millisecondsSinceEpoch / 1000,
      'audioUrl': audioUrl,
      'apiId': id,
    };
  }
}

class Edge {
  final String name;
  final String abbreviation;
  final String foot;

  Edge({this.name, this.abbreviation, this.foot});

  factory Edge.fromJson(Map<String, dynamic> json) {
    return Edge(
      name: json['name'],
      abbreviation: json['abbreviation'],
      foot: json['foot'],
    );
  }

  Map<String, String> toJson() {
    return {
      'name': name,
      'abbreviation': abbreviation,
      'foot': foot,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'move': move,
      'entry': entry,
      'exit': exit,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'abbreviation': abbreviation,
      'category': category,
    };
  }
}
