class TokenModel {
  final int id;
  final String name;
  final String symbol;
  final String slug;
  final String logo;
  final String featureImage;
  final String shortDescription;
  final String contractAddress;
  final bool stageStatus;
  final String stageDate;
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
  final String createdAt;
  final String updatedAt;
  final String fullName;
  final List<String> tags;

  TokenModel({
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
    required this.tags,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      slug: json['slug'],
      logo: json['logo'],
      featureImage: json['feature_image'],
      shortDescription: json['short_description'],
      contractAddress: json['contract_address'],
      stageStatus: json['stage_status'],
      stageDate: json['stage_date'],
      stageDateTimestamp: json['stage_date_timestamp'],
      sellTarget: json['sell_target'],
      alreadySell: json['already_sell'],
      sellPercentage: (json['sell_percentage'] as num).toDouble(),
      supporter: json['supporter'],
      tokenCompany: json['token_company'],
      companyDetails: json['company_details'],
      companyLogo: json['company_logo'],
      description: json['description'],
      ownerId: json['owner_id'],
      distributions: (json['distributions'] as List)
          .map((e) => Distribution.fromJson(e))
          .toList(),
      distributionImage: json['distribution_image'],
      status: json['status'],
      socialMedia: SocialMedia.fromJson(json['social_media']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      fullName: json['full_name'],
      tags: List<String>.from(json['tags']),
    );
  }
}

class Distribution {
  final String title;
  final String value;

  Distribution({
    required this.title,
    required this.value,
  });

  factory Distribution.fromJson(Map<String, dynamic> json) {
    return Distribution(
      title: json['title'],
      value: json['value'],
    );
  }
}

class SocialMedia {
  final String? twitter;
  final String? facebook;
  final String? linkedin;
  final String? telegram;

  SocialMedia({
    this.twitter,
    this.facebook,
    this.linkedin,
    this.telegram,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      twitter: json['twitter'],
      facebook: json['facebook'],
      linkedin: json['linkedin'],
      telegram: json['telegram'],
    );
  }
}
