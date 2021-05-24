part of 'models.dart';

class Ideas extends Equatable {

  final String ideaId;
  final String ideaTitle;
  final String ideaDesc;
  final String ideaCategory;
  final String ideaImage;
  final int ideaMaxParticipants;
  final int ideaParticipant;
  final String ideaBy;
  final String createdAt;
  final String updatedAt;

  Ideas(
      this.ideaId,
      this.ideaTitle,
      this.ideaDesc,
      this.ideaCategory,
      this.ideaImage,
      this.ideaMaxParticipants,
      this.ideaParticipant,
      this.ideaBy,
      this.createdAt,
      this.updatedAt
  );

  @override
  // TODO: implement props
  List<Object> get props => [
  ideaId,
  ideaTitle,
  ideaDesc,
  ideaCategory,
  ideaImage,
  ideaMaxParticipants,
  ideaParticipant,
  ideaBy,
  createdAt,
  updatedAt,
  ];

}

