class HomeStats {
  final int usersCount;
  final int teamsCount;
  final int eventsCount;
  final Map<String, dynamic>? upcomingEvent;

  HomeStats({required this.usersCount, required this.teamsCount, required this.eventsCount, this.upcomingEvent});

  factory HomeStats.fromJson(Map<String, dynamic> json) {
    return HomeStats(
      usersCount: json['users_count'] as int? ?? 0,
      teamsCount: json['teams_count'] as int? ?? 0,
      eventsCount: json['events_count'] as int? ?? 0,
      upcomingEvent: json['upcoming_event'] as Map<String, dynamic>?,
    );
  }
}
