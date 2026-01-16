import 'package:flutter/material.dart';
import '../models/TrainingZone.dart';

class ZoneSelector extends StatelessWidget {
  final List<TrainingZone> zones;
  final int? selectedZone;
  final ValueChanged<int> onSelected;

  const ZoneSelector({
    super.key,
    required this.zones,
    required this.selectedZone,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: zones.map((zone) {
        final isSelected = selectedZone == zone.value;

        return GestureDetector(
          onTap: () => onSelected(zone.value),
          child: Container(
            width: 110,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: zone.color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 3,
              ),
            ),
            child: Text(
              zone.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: zone.color == Colors.yellow
                    ? Colors.black
                    : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
