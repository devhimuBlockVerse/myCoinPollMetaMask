import 'dart:convert';

TokenDetails tokenDetailsFromJson(String str) => TokenDetails.fromJson(json.decode(str));

String tokenDetailsToJson(TokenDetails data) => json.encode(data.toJson());

class TokenDetails {
  final int id;
  final String name;
  final String symbol;
  final String slug;
  final String logo;
  final String featureImage;
  final String shortDescription;
  final String contractAddress;
  final bool stageStatus;
  final DateTime stageDate;
  final int stageDateTimestamp;
  final String sellTarget;
  final String alreadySell;
  final double sellPercentage;
  final int supporter;
  final String tokenCompany;
  final String companyDetails;
  final String companyLogo;
  final String description;
  final int ownerId;
  final List<Distribution> distributions;
  final String distributionImage;
  final bool status;
  final SocialMedia socialMedia;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String fullName;
  final Owner owner;
  final Roadmap roadmap;
  final List<String> tags;

  TokenDetails({
    required this.id,
    required this.name,
    required this.symbol,
    required this.slug,
    required this.logo,
    required this.featureImage,
    required this.shortDescription,
    required this.contractAddress,
    required this.stageStatus,
    required this.stageDate,
    required this.stageDateTimestamp,
    required this.sellTarget,
    required this.alreadySell,
    required this.sellPercentage,
    required this.supporter,
    required this.tokenCompany,
    required this.companyDetails,
    required this.companyLogo,
    required this.description,
    required this.ownerId,
    required this.distributions,
    required this.distributionImage,
    required this.status,
    required this.socialMedia,
    required this.createdAt,
    required this.updatedAt,
    required this.fullName,
    required this.owner,
    required this.roadmap,
    required this.tags,
  });

  factory TokenDetails.fromJson(Map<String, dynamic> json) => TokenDetails(
    id: json["id"],
    name: json["name"],
    symbol: json["symbol"],
    slug: json["slug"],
    logo: json["logo"],
    featureImage: json["feature_image"],
    shortDescription: json["short_description"],
    contractAddress: json["contract_address"],
    stageStatus: json["stage_status"],
    stageDate: DateTime.parse(json["stage_date"]),
    stageDateTimestamp: json["stage_date_timestamp"],
    sellTarget: json["sell_target"],
    alreadySell: json["already_sell"],
    sellPercentage: json["sell_percentage"]?.toDouble(),
    supporter: json["supporter"],
    tokenCompany: json["token_company"],
    companyDetails: json["company_details"],
    companyLogo: json["company_logo"],
    description: json["description"],
    ownerId: json["owner_id"],
    distributions: List<Distribution>.from(json["distributions"].map((x) => Distribution.fromJson(x))),
    distributionImage: json["distribution_image"],
    status: json["status"],
    socialMedia: SocialMedia.fromJson(json["social_media"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    fullName: json["full_name"],
    owner: Owner.fromJson(json["owner"]),
    roadmap: Roadmap.fromJson(json["roadmap"]),
    tags: List<String>.from(json["tags"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "symbol": symbol,
    "slug": slug,
    "logo": logo,
    "feature_image": featureImage,
    "short_description": shortDescription,
    "contract_address": contractAddress,
    "stage_status": stageStatus,
    "stage_date": stageDate.toIso8601String(),
    "stage_date_timestamp": stageDateTimestamp,
    "sell_target": sellTarget,
    "already_sell": alreadySell,
    "sell_percentage": sellPercentage,
    "supporter": supporter,
    "token_company": tokenCompany,
    "company_details": companyDetails,
    "company_logo": companyLogo,
    "description": description,
    "owner_id": ownerId,
    "distributions": List<dynamic>.from(distributions.map((x) => x.toJson())),
    "distribution_image": distributionImage,
    "status": status,
    "social_media": socialMedia.toJson(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "full_name": fullName,
    "owner": owner.toJson(),
    "roadmap": roadmap.toJson(),
    "tags": List<dynamic>.from(tags.map((x) => x)),
  };
}

class Distribution {
  final String title;
  final String value;

  Distribution({
    required this.title,
    required this.value,
  });

  factory Distribution.fromJson(Map<String, dynamic> json) => Distribution(
    title: json["title"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "value": value,
  };
}

class Owner {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String username;
  final dynamic avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  Owner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.username,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    username: json["username"],
    avatar: json["avatar"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "username": username,
    "avatar": avatar,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Roadmap {
  final int id;
  final int tokenId;
  final List<RoadmapDatum> roadmapData;
  final DateTime createdAt;
  final DateTime updatedAt;

  Roadmap({
    required this.id,
    required this.tokenId,
    required this.roadmapData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Roadmap.fromJson(Map<String, dynamic> json) => Roadmap(
    id: json["id"],
    tokenId: json["token_id"],
    roadmapData: List<RoadmapDatum>.from(json["roadmap_data"].map((x) => RoadmapDatum.fromJson(x))),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token_id": tokenId,
    "roadmap_data": List<dynamic>.from(roadmapData.map((x) => x.toJson())),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class RoadmapDatum {
  final String name;
  final List<Task> tasks;
  final String heading;

  RoadmapDatum({
    required this.name,
    required this.tasks,
    required this.heading,
  });

  factory RoadmapDatum.fromJson(Map<String, dynamic> json) => RoadmapDatum(
    name: json["name"],
    tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
    heading: json["heading"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
    "heading": heading,
  };
}

class Task {
  final String name;
  final bool status;

  Task({
    required this.name,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    name: json["name"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "status": status,
  };
}

class SocialMedia {
  final String? twitter;
  final dynamic facebook;
  final dynamic linkedin;
  final String? telegram;

  SocialMedia({
    this.twitter,
    this.facebook,
    this.linkedin,
    this.telegram,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) => SocialMedia(
    twitter: json["twitter"],
    facebook: json["facebook"],
    linkedin: json["linkedin"],
    telegram: json["telegram"],
  );

  Map<String, dynamic> toJson() => {
    "twitter": twitter,
    "facebook": facebook,
    "linkedin": linkedin,
    "telegram": telegram,
  };
}