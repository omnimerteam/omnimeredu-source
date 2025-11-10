import 'package:flutter/material.dart';

class TuitionManagementCenterScreen extends StatelessWidget {
  const TuitionManagementCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> quickLinks = [
      {
        'title': 'Quản lý học phí',
        'description':
            'Xem và quản lý danh sách học phí của sinh viên theo kỳ học.',
        'route': '/tuition/list',
      },
      {
        'title': 'Tính tiền học phí',
        'description':
            'Thực hiện tính toán học phí tự động theo chính sách hiện hành.',
        'route': '/tuition/calculate',
      },
      {
        'title': 'Phụ thu',
        'description':
            'Thiết lập và theo dõi các khoản phụ thu trong từng kỳ học.',
        'route': '/school-admin/tuition/extra-fee',
      },
      {
        'title': 'Chính sách giảm giá',
        'description': 'Quản lý chính sách học bổng, miễn giảm, giảm học phí.',
        'route': '/tuition/discount-policy',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tuition Admin'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trung tâm quản lý học phí',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Điều hướng nhanh đến các module chính trong hệ thống học phí.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemCount: quickLinks.length,
                itemBuilder: (context, index) {
                  final item = quickLinks[index];
                  return _QuickLinkCard(
                    title: item['title']!,
                    description: item['description']!,
                    onTap: () => Navigator.pushNamed(context, item['route']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  child: const Text('Truy cập'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
