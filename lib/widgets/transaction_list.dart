import '/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key, required this.transactions, required this.deleteTxn}) : super(key: key);

  final List<Transaction> transactions;
  final Function deleteTxn;
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
            children: [
              Text(
                'No Expenses',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 300,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          )
        : ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final txn = transactions[index];
              return Card(
                color: Colors.cyan.shade50,
                elevation: 5,
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.cyan.shade400,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FittedBox(
                        child: Text(
                          '\$${txn.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.cyan.shade400,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(txn.title, style: Theme.of(context).textTheme.headline1),
                          Text(
                            DateFormat.yMMMMd().format(txn.date),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MediaQuery.of(context).size.width > 380
                        ? TextButton.icon(
                            onPressed: () => deleteTxn(txn.id),
                            icon: const Icon(
                              Icons.delete,
                            ),
                            label: const Text('Delete'),
                            style: TextButton.styleFrom(
                              primary: Colors.red,
                            ),
                          )
                        : IconButton(
                            onPressed: () => deleteTxn(txn.id),
                            icon: const Icon(
                              Icons.delete,
                            )),
                  ],
                ),
              );
            },
          );
  }
}
