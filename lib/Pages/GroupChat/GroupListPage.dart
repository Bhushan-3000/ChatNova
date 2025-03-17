import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatnova/Pages/GroupChat/GroupChatPage.dart';

class GroupListPage extends StatefulWidget {
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final String userId = Supabase.instance.client.auth.currentUser!.id;

  Future<Map<String, dynamic>> _getLastMessage(String groupId) async {
    final response = await supabase
        .from('group_messages')
        .select('message, sender_id, timestamp')
        .eq('group_id', groupId)
        .order('timestamp', ascending: false)
        .limit(1)
        .maybeSingle();
    return response ?? {};
  }

  Future<int> _getUnreadMessageCount(String groupId) async {
    final response = await supabase
        .from('group_messages')
        .select('id')
        .eq('group_id', groupId)
        .neq('sender_id', userId);
    return response.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Groups'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.blueAccent,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('group_members')
            .stream(primaryKey: ['id'])
            .eq('user_id', userId)
            .map((groupMembers) => groupMembers.map((g) => g['group_id'] as String).toList())
            .asyncMap((groupIds) async {
          if (groupIds.isEmpty) return <Map<String, dynamic>>[];
          return await supabase.from('groups').select('*').inFilter('id', groupIds);
        }),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final groups = snapshot.data!;
          if (groups.isEmpty) return Center(child: Text('No groups found', style: TextStyle(color: Colors.white)));

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return FutureBuilder(
                future: Future.wait([
                  _getLastMessage(group['id']),
                  _getUnreadMessageCount(group['id'])
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) return ListTile(title: Text(group['name']));
                  final lastMessage = snapshot.data![0] as Map<String, dynamic>;
                  final unreadCount = snapshot.data![1] as int;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: group['image_url'] != null ? NetworkImage(group['image_url']) : null,
                          child: group['image_url'] == null ? Icon(Icons.group, color: Colors.black) : null,
                        ),
                        title: Text(group['name'], style: TextStyle(color: Colors.black)),
                        subtitle: lastMessage.isNotEmpty
                            ? Text(lastMessage['message'] ?? 'Image sent',
                            maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.blueGrey))
                            : Text('No messages yet', style: TextStyle(color: Colors.white70)),
                        trailing: unreadCount > 0
                            ? CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Text(unreadCount.toString(), style: TextStyle(color: Colors.white, fontSize: 12)),
                        )
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupChatPage(
                                groupId: group['id'],
                                groupName: group['name'],
                                groupImageUrl: group['image_url'] ?? '',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),

    );
  }
}
