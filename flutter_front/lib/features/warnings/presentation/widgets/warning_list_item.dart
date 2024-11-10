import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/warning.dart';
import '../bloc/warnings_bloc.dart';
import 'description_dialog.dart';

class WarningListItem extends StatefulWidget {
  final Warning warning;

  const WarningListItem({super.key, required this.warning});

  @override
  State<WarningListItem> createState() => _WarningListItemState();
}

class _WarningListItemState extends State<WarningListItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WarningsBloc>();
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.warning.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: widget.warning.viewed ? Colors.grey : null,
                              ),
                            ),
                          ),
                          if(widget.warning.description != null)
                            const Icon(
                              Icons.message,
                              color: Colors.grey,
                              size: 16,
                            ),
                          const SizedBox(width: 5),
                          if (widget.warning.viewed)
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 16,
                            ) else
                            const Icon(
                              Icons.warning_amber_sharp,
                              color: Colors.orangeAccent,
                              size: 16,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Период: ${widget.warning.dateFrom} - ${widget.warning.dateTo}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Превышение: ${widget.warning.excessPercent.toStringAsFixed(2)}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isHovering ? 1.0 : 0.0,
                child: Container(
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: _isHovering
                        ? Colors.grey.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: widget.warning.viewed
                                ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            widget.warning.viewed ? Icons.close : Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        onPressed: () {
                          context
                              .read<WarningsBloc>()
                              .add(ToggleWarningViewed(
                            widget.warning,
                            !widget.warning.viewed,
                          ));
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () => showDescriptionDialog(context, bloc, widget),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}