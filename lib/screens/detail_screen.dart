import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:json_place_holder/models/user.dart';

class DetailScreen extends StatelessWidget {
  final User user;

  const DetailScreen({super.key, required this.user});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (!await launchUrl(uri)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(user.name),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark,
                    ],
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.name[0],
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de información básica
                  _buildSectionTitle('Información de Contacto'),
                  _buildInfoRow(Icons.alternate_email, 'Usuario', '@${user.username}'),
                  _buildClickableRow(
                    Icons.email,
                    'Email',
                    user.email,
                    () => _launchURL('mailto:${user.email}'),
                  ),
                  _buildClickableRow(
                    Icons.phone,
                    'Teléfono',
                    user.phone,
                    () => _launchURL('tel:${user.phone}'),
                  ),
                  _buildClickableRow(
                    Icons.language,
                    'Sitio web',
                    user.website,
                    () => _launchURL('https://${user.website}'),
                  ),

                  const SizedBox(height: 24),
                  // Sección de dirección
                  _buildSectionTitle('Dirección'),
                  Text(
                    '${user.address.street}, ${user.address.suite}\n'
                    '${user.address.city}, ${user.address.zipcode}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),
                  // Sección de compañía
                  _buildSectionTitle('Compañía'),
                  Text(
                    user.company.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${user.company.catchPhrase}"',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    user.company.bs,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableRow(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: _buildInfoRow(icon, label, value),
    );
  }
}
