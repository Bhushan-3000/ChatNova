import 'package:chatnova/Pages/GroupChat/GroupSettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupImageUrl;

  GroupInfoPage({
    required this.groupId,
    required this.groupName,
    required this.groupImageUrl,
  });

  @override
  _GroupInfoPageState createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchGroupMembers() async {
    try {
      final response = await supabase
          .from('group_members')
          .select('user_id, users!inner(name, profileimage)')
          .eq('group_id', widget.groupId);

      if (response.isEmpty) {
        return [];
      }

      return response.map((member) {
        return {
          'name': member['users']['name'] ?? 'Unknown',
          'profileimage': member['users']['profileimage'] ?? '',
        };
      }).toList();
    } catch (error) {
      print("Error fetching group members: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Info"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {
            Get.to(() => GroupSettingsPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              groupImageUrl: widget.groupImageUrl,
            ));
          }),        ],
      ),
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300, // Default color
                    radius: 100,
                    backgroundImage: widget.groupImageUrl.isNotEmpty
                        ? NetworkImage(widget.groupImageUrl)
                        : null,
                    child: widget.groupImageUrl.isEmpty
                        ? Icon(Icons.group, color: Colors.black,size: 100,)
                        : null,
                  ),                  SizedBox(height: 10),
                  Text(
                    widget.groupName,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Group Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchGroupMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading members", style: TextStyle(color: Colors.white)));
                }
                final members = snapshot.data!;
                if (members.isEmpty) {
                  return Center(child: Text("No members found", style: TextStyle(color: Colors.white)));
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: members.map((member) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Added padding
                              leading: CircleAvatar(
                                radius: 30, // Adjusted size
                                backgroundImage: member['profileimage'].isNotEmpty
                                    ? NetworkImage(member['profileimage'])
                                    : AssetImage('assets/default_profile.png') as ImageProvider,
                              ),
                              title: Text(
                                member['name'],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 10), // Added spacing
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
