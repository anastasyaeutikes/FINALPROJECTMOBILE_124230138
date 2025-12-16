// lib/screens/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../database/database_helper.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadProfileImage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(kLoggedInUsernameKey);

    if (username != null) {
      final user = await DatabaseHelper.instance.getUserByUsername(username);
      if (!mounted) return;
      setState(() {
        _currentUser = user;
        _nameController.text = user?.name ?? '';
      });
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      if (!mounted) return;
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_path', pickedFile.path);

        if (!mounted) return;
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Profile Picture',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: Colors.pink),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.pink),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_imageFile != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Remove Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _removeProfileImage();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_path');

    if (!mounted) return;
    setState(() {
      _imageFile = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture removed'),
        backgroundColor: Colors.grey,
      ),
    );
  }

  Future<void> _updateName() async {
    if (_currentUser == null || _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final updatedUser = User(
        id: _currentUser!.id,
        name: _nameController.text.trim(),
        username: _currentUser!.username,
        email: _currentUser!.email,
        password: _currentUser!.password,
      );

      await DatabaseHelper.instance.updateUser(updatedUser);

      if (!mounted) return;
      setState(() {
        _currentUser = updatedUser;
        _isEditingName = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating name: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _logout() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kIsLoggedInKey, false);
      await prefs.remove(kLoggedInUsernameKey);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header with Avatar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar with Edit Button
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.pink.shade100,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.pink.shade50,
                                backgroundImage: _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : null,
                                child: _imageFile == null
                                    ? Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.pink.shade300,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _showImageSourceDialog,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentUser!.username,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Profile Information Cards
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Name Card (Editable)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.pink.shade300,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Full Name',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isEditingName ? Icons.check : Icons.edit,
                                      color: Colors.pink,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      if (_isEditingName) {
                                        _updateName();
                                      } else {
                                        setState(() {
                                          _isEditingName = true;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (_isEditingName)
                                TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.pink.shade200,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.pink,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  autofocus: true,
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(left: 36),
                                  child: Text(
                                    _currentUser!.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Username Card
                        _buildProfileCard(
                          Icons.account_circle,
                          'Username',
                          _currentUser!.username,
                        ),
                        const SizedBox(height: 12),

                        // Email Card
                        _buildProfileCard(
                          Icons.email,
                          'Email',
                          _currentUser!.email,
                        ),
                        const SizedBox(height: 12),

                        // Password Card (Hashed)
                        _buildProfileCard(
                          Icons.lock,
                          'Password',
                          '••••••••••••',
                          subtitle: 'Your password is securely encrypted',
                        ),
                        const SizedBox(height: 20),

                        // Kesan dan Pesan Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.message,
                                    color: Colors.pink.shade300,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Kesan dan Pesan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Kesan
                              const Text(
                                'Kesan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Selama mengikuti mata kuliah Pemrograman Aplikasi Mobile, saya merasa sangat terbantu dalam memahami bagaimana sebuah aplikasi dapat dibangun dari awal hingga siap digunakan. Materinya disampaikan dengan jelas dan proses pembelajaran juga terasa menyenangkan karena disertai tugas akhir yang membuat saya menjadi sangat produktif hingga kehilangan tidur yang nyenyak. Secara keseluruhan, mata kuliah ini sangat menambah wawasan dan skill saya dalam memahami dan menghadapi diri sendiri.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 16),

                              // Pesan
                              const Text(
                                'Pesan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Saya berharap ke depannya materi dapat ditambah dengan lebih banyak praktik agar mahasiswa semakin terbiasa menghadapi permasalahan. Selain itu, mungkin bisa ditambahkan sesi live coding agar mahasiswa mendapatkan gambaran lebih luas tentang mata kuliah Pemrograman Aplikasi Mobile ini. Terima kasih kepada Bapak Bagus Muhammad Akbar, S.T., M.Kom sebagai pengampu mata kuliah Pemrograman Aplikasi Mobile yang sudah membimbing saya dengan jelas, ceria, dan sangat suportif. Semoga Bapak selalu sehat dan sukses dalam setiap langkah ke depannya.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Info Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your password is stored securely using encryption for your safety.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue.shade900,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileCard(
    IconData icon,
    String title,
    String value, {
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink.shade300),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
