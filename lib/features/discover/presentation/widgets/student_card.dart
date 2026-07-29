class StudentCard extends StatelessWidget {
  final DiscoverUser user;

  const StudentCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        // We'll replace this with the Profile screen next
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Opening ${user.name}'s profile"),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              // Your existing CircleAvatar...
              // Your existing user details...
            ],
          ),
        ),
      ),
    );
  }
}