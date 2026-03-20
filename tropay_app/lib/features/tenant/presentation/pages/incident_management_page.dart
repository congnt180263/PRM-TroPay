import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tenant_provider.dart';
import '../../data/models/incident_model.dart';
import '../../../../core/utils/format_utils.dart';

class IncidentManagementPage extends StatefulWidget {
  const IncidentManagementPage({super.key});

  @override
  State<IncidentManagementPage> createState() => _IncidentManagementPageState();
}

class _IncidentManagementPageState extends State<IncidentManagementPage> {
  String? _statusFilter;
  String? _priorityFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sự cố'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Consumer<TenantProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingIncidents) {
            return const Center(child: CircularProgressIndicator());
          }

          final filtered = _applyFilters(provider.incidents);

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.incidents.isEmpty
                        ? 'Không có sự cố nào'
                        : 'Không có sự cố khớp bộ lọc',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadIncidents(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length + (_hasFilters ? 1 : 0),
              itemBuilder: (context, index) {
                if (_hasFilters && index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (_statusFilter != null)
                          FilterChip(
                            label: Text('Trạng thái: ${_statusLabel(_statusFilter!)}'),
                            onSelected: (_) => _clearStatus(),
                          ),
                        if (_priorityFilter != null)
                          FilterChip(
                            label: Text('Độ ưu tiên: ${_priorityLabel(_priorityFilter!)}'),
                            onSelected: (_) => _clearPriority(),
                          ),
                        TextButton.icon(
                          onPressed: _clearFilters,
                          icon: const Icon(Icons.close),
                          label: const Text('Xóa bộ lọc'),
                        ),
                      ],
                    ),
                  );
                }

                final incident = filtered[_hasFilters ? index - 1 : index];
                return _buildIncidentCard(context, incident);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showReportIncidentDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Báo cáo sự cố'),
      ),
    );
  }

  bool get _hasFilters => _statusFilter != null || _priorityFilter != null;

  List<IncidentModel> _applyFilters(List<IncidentModel> incidents) {
    return incidents.where((incident) {
      final matchesStatus = _statusFilter == null || incident.status == _statusFilter;
      final matchesPriority = _priorityFilter == null || incident.priority == _priorityFilter;
      return matchesStatus && matchesPriority;
    }).toList();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        String? selectedStatus = _statusFilter;
        String? selectedPriority = _priorityFilter;

        Widget buildChips(List<String> options, String? value, void Function(String?) onChanged) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: value == _statusKey(option) || value == _priorityKey(option),
                onSelected: (isSelected) {
                  final key = _statusKey(option) ?? _priorityKey(option);
                  onChanged(isSelected ? key : null);
                },
              );
            }).toList(),
          );
        }

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bộ lọc sự cố',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text('Trạng thái', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    buildChips(
                      const ['Tất cả', 'Chờ xử lý', 'Đang xử lý', 'Đã giải quyết', 'Đã từ chối'],
                      selectedStatus,
                      (value) => setModalState(() => selectedStatus = value),
                    ),
                    const SizedBox(height: 16),
                    Text('Độ ưu tiên', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    buildChips(
                      const ['Tất cả', 'Khẩn cấp', 'Cao', 'Trung bình', 'Thấp'],
                      selectedPriority,
                      (value) => setModalState(() => selectedPriority = value),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _statusFilter = null;
                                _priorityFilter = null;
                              });
                              Navigator.pop(sheetContext);
                            },
                            child: const Text('Xóa bộ lọc'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                _statusFilter = selectedStatus;
                                _priorityFilter = selectedPriority;
                              });
                              Navigator.pop(sheetContext);
                            },
                            child: const Text('Áp dụng'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _clearFilters() {
    setState(() {
      _statusFilter = null;
      _priorityFilter = null;
    });
  }

  void _clearStatus() {
    setState(() => _statusFilter = null);
  }

  void _clearPriority() {
    setState(() => _priorityFilter = null);
  }

  String _statusLabel(String key) {
    switch (key) {
      case 'pending':
        return 'Chờ xử lý';
      case 'in_progress':
        return 'Đang xử lý';
      case 'resolved':
        return 'Đã giải quyết';
      case 'rejected':
        return 'Đã từ chối';
      default:
        return 'Tất cả';
    }
  }

  String _priorityLabel(String key) {
    switch (key) {
      case 'urgent':
        return 'Khẩn cấp';
      case 'high':
        return 'Cao';
      case 'medium':
        return 'Trung bình';
      case 'low':
        return 'Thấp';
      default:
        return 'Tất cả';
    }
  }

  String? _statusKey(String label) {
    switch (label) {
      case 'Chờ xử lý':
        return 'pending';
      case 'Đang xử lý':
        return 'in_progress';
      case 'Đã giải quyết':
        return 'resolved';
      case 'Đã từ chối':
        return 'rejected';
      case 'Tất cả':
        return null;
    }
    return null;
  }

  String? _priorityKey(String label) {
    switch (label) {
      case 'Khẩn cấp':
        return 'urgent';
      case 'Cao':
        return 'high';
      case 'Trung bình':
        return 'medium';
      case 'Thấp':
        return 'low';
      case 'Tất cả':
        return null;
    }
    return null;
  }

  Widget _buildIncidentCard(BuildContext context, IncidentModel incident) {
    Color statusColor;
    String statusText;

    switch (incident.status) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'Chờ xử lý';
        break;
      case 'in_progress':
        statusColor = Colors.blue;
        statusText = 'Đang xử lý';
        break;
      case 'resolved':
        statusColor = Colors.green;
        statusText = 'Đã giải quyết';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Đã từ chối';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Không xác định';
    }

    Color priorityColor;
    switch (incident.priority) {
      case 'urgent':
        priorityColor = Colors.red;
        break;
      case 'high':
        priorityColor = Colors.orange;
        break;
      case 'medium':
        priorityColor = Colors.blue;
        break;
      default:
        priorityColor = Colors.grey;
    }

    IconData categoryIcon;
    switch (incident.category) {
      case 'electrical':
        categoryIcon = Icons.electrical_services;
        break;
      case 'plumbing':
        categoryIcon = Icons.water_drop;
        break;
      case 'furniture':
        categoryIcon = Icons.chair;
        break;
      default:
        categoryIcon = Icons.build;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showIncidentDetail(context, incident);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: statusColor.withValues(alpha: 0.2),
                    child: Icon(categoryIcon, color: statusColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          FormatUtils.formatTimeAgo(incident.createdAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: priorityColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      incident.priority == 'urgent'
                          ? 'Khẩn cấp'
                          : incident.priority == 'high'
                              ? 'Cao'
                              : incident.priority == 'medium'
                                  ? 'Trung bình'
                                  : 'Thấp',
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                incident.description,
                style: TextStyle(color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (incident.response != null) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.message, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Có phản hồi',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIncidentDetail(BuildContext context, IncidentModel incident) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chi tiết sự cố',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                incident.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildDetailItem('Mô tả', incident.description),
              _buildDetailItem('Danh mục', _getCategoryText(incident.category)),
              _buildDetailItem('Mức độ ưu tiên', _getPriorityText(incident.priority)),
              _buildDetailItem('Trạng thái', _getStatusText(incident.status)),
              _buildDetailItem('Thời gian báo cáo', FormatUtils.formatDateTime(incident.createdAt)),
              if (incident.resolvedAt != null)
                _buildDetailItem('Thời gian giải quyết', FormatUtils.formatDateTime(incident.resolvedAt!)),
              if (incident.response != null) ...[
                const Divider(height: 32),
                Text(
                  'Phản hồi từ chủ nhà',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(incident.response!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryText(String category) {
    switch (category) {
      case 'electrical':
        return 'Điện';
      case 'plumbing':
        return 'Nước';
      case 'furniture':
        return 'Nội thất';
      default:
        return 'Khác';
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'urgent':
        return 'Khẩn cấp';
      case 'high':
        return 'Cao';
      case 'medium':
        return 'Trung bình';
      default:
        return 'Thấp';
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xử lý';
      case 'in_progress':
        return 'Đang xử lý';
      case 'resolved':
        return 'Đã giải quyết';
      case 'rejected':
        return 'Đã từ chối';
      default:
        return 'Không xác định';
    }
  }

  void _showReportIncidentDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'electrical';
    String selectedPriority = 'medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Báo cáo sự cố'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả chi tiết',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Danh mục',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'electrical', child: Text('Điện')),
                    DropdownMenuItem(value: 'plumbing', child: Text('Nước')),
                    DropdownMenuItem(value: 'furniture', child: Text('Nội thất')),
                    DropdownMenuItem(value: 'other', child: Text('Khác')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Mức độ ưu tiên',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Thấp')),
                    DropdownMenuItem(value: 'medium', child: Text('Trung bình')),
                    DropdownMenuItem(value: 'high', child: Text('Cao')),
                    DropdownMenuItem(value: 'urgent', child: Text('Khẩn cấp')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  context.read<TenantProvider>().reportIncident(
                        title: titleController.text,
                        description: descriptionController.text,
                        category: selectedCategory,
                        priority: selectedPriority,
                      );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã báo cáo sự cố thành công')),
                  );
                }
              },
              child: const Text('Gửi báo cáo'),
            ),
          ],
        ),
      ),
    );
  }
}
