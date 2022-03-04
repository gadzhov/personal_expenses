import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

typedef DeleteTranType = void Function(String id);

class TransactionList extends StatelessWidget {
  const TransactionList(this._transactions, this._deleteTransaction, {Key? key})
      : super(key: key);

  final List<Transaction> _transactions;
  final DeleteTranType _deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(builder: ((BuildContext _, BoxConstraints constraints) {
            return Column(
              children: [
                const Text('No transactions added yet!'),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          }))
        : ListView.builder(
            itemBuilder: ((context, index) {
              final tx = _transactions[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 8,
                ),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text('\$${tx.amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    tx.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(tx.date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 480
                      ? TextButton.icon(
                          onPressed: () => _deleteTransaction(tx.id),
                          style: TextButton.styleFrom(
                            primary: Theme.of(context).errorColor,
                          ),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                        )
                      : IconButton(
                          onPressed: () => _deleteTransaction(tx.id),
                          color: Theme.of(context).errorColor,
                          icon: const Icon(
                            Icons.delete,
                          )),
                ),
              );
            }),
            itemCount: _transactions.length,
          );
  }
}
