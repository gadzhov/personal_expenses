import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef NewTransactionType = void Function(
    String title, double amount, DateTime date);

class NewTransaction extends StatefulWidget {
  const NewTransaction(this._addNewTransaction, {Key? key}) : super(key: key);

  final NewTransactionType _addNewTransaction;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _onSubmit() {
    if (!_isFormValid()) {
      return;
    }

    final title = _titleController.text;
    final amount = double.parse(_amountController.text);
    widget._addNewTransaction(title, amount, _selectedDate!);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now());

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  bool _isFormValid() =>
      _titleController.text.trim().isNotEmpty &&
      _amountController.text.trim().isNotEmpty &&
      _selectedDate != null;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 10,
            right: 10,
            top: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                onSubmitted: (_) => _onSubmit,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _onSubmit(),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: _selectedDate == null
                            ? const Text('No Date Chosen!')
                            : Text(
                                'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}')),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _isFormValid() ? _onSubmit : null,
                child: Text(
                  'Add transaction',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.button?.color,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
