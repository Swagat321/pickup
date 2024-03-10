import "package:flutter/material.dart";

class BottomNavBar extends StatefulWidget {
  void Function(int)? onChange;
  int index;

  BottomNavBar(
      {super.key, required this.onChange, required this.index});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // backgroundColor: Colors.blue, // Set a non-transparent background color
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_sharp),
          label: "Create",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Discover",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: "Chat",
        ),
      ],
      currentIndex: widget.index,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.red.shade400,
      unselectedLabelStyle:
          TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold),
      onTap: widget.onChange,
    );
  }
}
