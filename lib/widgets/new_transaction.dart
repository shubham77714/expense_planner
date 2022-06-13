import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction(this.addTx, {Key? key}) : super(key: key);

  final Function addTx;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.pop(context);
  }

  void _showdatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.name,
                controller: _titleController,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _amountController,
                decoration: const InputDecoration(
                  label: Text('Amount'),
                ),
                onSubmitted: (_) => _submitData(),
              ),
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _showdatePicker();
                },
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 0.7),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          _selectedDate == null ? 'Select Date' : DateFormat.yMMMMd().format(_selectedDate!)),
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _showdatePicker();
                          },
                          icon: const Icon(Icons.calendar_today))
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(
                  "Add Transaction",
                  style: Theme.of(context).textTheme.button,
                ),
                style: Theme.of(context).elevatedButtonTheme.style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
