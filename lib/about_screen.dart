import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  void _launchURL() async {
    final Uri url = Uri.parse("https://github.com/yourgroup/food-truck-app");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About - Food Truck Tracker'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: const [
                      Icon(Icons.fastfood, size: 60, color: Colors.orange),
                      SizedBox(height: 10),
                      Text(
                        'Food Truck Tracker',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'ITT602 Mobile Application Development',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  'Developers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Ariessa Nur Ain Binti Abu Zahri'),
                  subtitle: Text('Student ID: 2023135733'),
                ),
                const ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Anis Nur Atikah Binti Ismail'),
                  subtitle: Text('Student ID: 2023141109'),
                ),
                const ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Nur Athirah Syafiqah Binti Mohd Yusuf'),
                  subtitle: Text('Student ID: 2023365647'),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Group & Programme',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Group'),
                  subtitle: Text('RCDCS2515A'),
                ),
                const ListTile(
                  leading: Icon(Icons.school),
                  title: Text('Programme Code'),
                  subtitle: Text('ICT602'),
                ),

                const SizedBox(height: 20),
                const Text(
                  '© 2025 Food Truck Tracker Team. All rights reserved.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.link),
                    label: const Text('View GitHub Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _launchURL,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
