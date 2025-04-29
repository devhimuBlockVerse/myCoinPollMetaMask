import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/components/buy_Ecm.dart';
import 'package:provider/provider.dart';

import '../../../framework/components/statke_now_animation_button.dart';
import 'package:intl/intl.dart';

import '../../../framework/utils/routes/route_names.dart';
import '../viewmodel/wallet_view_model.dart';

class EcmStakingScreen extends StatefulWidget {
  const EcmStakingScreen({super.key});

  @override
  State<EcmStakingScreen> createState() => _EcmStakingScreenState();
}
class _EcmStakingScreenState extends State<EcmStakingScreen> {
  String selectedPercentage = ''; // Default selected
  String selectedDay = '7D'; // Default selected

  double estimatedProfit = 0.0;
  double totalWithReward = 0.0;
  DateTime? unlockDate;

  String lockOverviewText = '';
  String durationDisplayText = '';


  final TextEditingController _searchController = TextEditingController();
  final TextEditingController ecmAmountController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  List<Map<String, String>> _stakingData = [];
  List<Map<String, String>> _filteredData = [];

   final Map<String, double> annualReturnRates = {
    '7D': 0.05,
    '30D': 0.08,
    '90D': 0.11,
    '180D': 0.15,
    '365D': 0.20,

  };

  void calculateRewards() {
    double ecmAmount = double.tryParse(ecmAmountController.text) ?? 0.0;

    if (ecmAmount <= 0) {
       estimatedProfit = 0.0;
      totalWithReward = 0.0;
      unlockDate = null;
      lockOverviewText = '';
      setState(() {});
      return;
    }

    int numberOfDays = int.tryParse(selectedDay.replaceAll('D', '')) ?? 7;
    double annualRate = annualReturnRates[selectedDay] ?? 0.05;
    double dailyRate = annualRate / 365;

    estimatedProfit = ecmAmount * dailyRate * numberOfDays;
    totalWithReward = ecmAmount + estimatedProfit;
    unlockDate = DateTime.now().add(Duration(days: numberOfDays));

    lockOverviewText = "My ${ecmAmount.toStringAsFixed(0)} ECM Staked for $numberOfDays Days";

    setState(() {});
  }

   void selectDuration(String duration) {
    setState(() {
      selectedDay = duration;
    });
    calculateRewards();
  }

  String formatDateWithSuffix(DateTime date) {
    int day = date.day;
    String suffix = 'th';
    if (day == 1 || day == 21 || day == 31) suffix = 'st';
    else if (day == 2 || day == 22) suffix = 'nd';
    else if (day == 3 || day == 23) suffix = 'rd';

    String formatted = "${day}$suffix, ${DateFormat('MMMM yyyy hh:mm a').format(date)}";
    return formatted;
  }
  void _onSearchChanged() {

    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _stakingData.where((row){
        return row.values.any((value) => value.toLowerCase().contains(query));
      }).toList();
    });
  }

  String? balance;
  bool isLoading = true;
  String? error;


  @override
  void initState() {
    super.initState();
    _loadDummyData();
    _filteredData = List.from(_stakingData);
    ecmAmountController.addListener(calculateRewards);
    calculateRewards();
     final walletProvider = Provider.of<WalletViewModel>(context, listen: false);
    walletProvider.getBalance();
  }
  @override
  void dispose() {
    ecmAmountController.removeListener(calculateRewards);
    ecmAmountController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF0A1C2F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'ECM Staking',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0x4d03080e),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF0A1C2F),
                Color(0xFF060D13),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // 5% padding from each side
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                ///Stack Input ECM and Percentage Section
                ecmInputSection(textScale, screenWidth, screenHeight),

                SizedBox(height: 8),

                /// Stack ECM Validity And Day's Section
                validitySection(textScale, screenWidth, screenHeight),

                SizedBox(height: 8),

                /// Lock OverView Container
                lockOverViewSection(textScale, screenWidth, screenHeight),
                SizedBox(height: 18),

                /// Stack Amount , Profile , Total Reward Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                   decoration: BoxDecoration(
                     color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.blueGrey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                      // _ecmAmountRow("Stack amount", "100 ECM"),
                       _ecmAmountRow("Stack amount", "${ecmAmountController.text} ECM"),

                       const Divider(color: Colors.white24,thickness: 1,),
                      // _ecmAmountRow("Estimated Profit", "0.658 ECM", highlight: true),
                       _ecmAmountRow("Estimated Profit", "${estimatedProfit.toStringAsFixed(3)} ECM", highlight: true),

                       const Divider(color: Colors.white24),
                      // _ecmAmountRow("Total with Reward", "100.658 ECM"),
                       _ecmAmountRow("Total with Reward", "${totalWithReward.toStringAsFixed(3)} ECM"),

                     ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.blueGrey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // _ecmValidityRow("Annual Return Rate", "5%"),
                      _ecmValidityRow("Annual Return Rate", "${(annualReturnRates[selectedDay] ?? 0.05) * 100}%"),

                      const Divider(color: Colors.white24,thickness: 1,),
                      // _ecmValidityRow("Duration", "7 Days", highlight: true),
                      _ecmValidityRow("Duration", "${selectedDay.replaceAll('D', '')} Days", highlight: true),

                      const Divider(color: Colors.white24),
                      // _ecmValidityRow("Unlocked on", "3rd, May 2025 11:26 PM"),
                      _ecmValidityRow("Unlocked On", unlockDate != null ? formatDateWithSuffix(unlockDate!) : "Not Available"),



                    ],
                  ),
                ),
                SizedBox(height: 8),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: Row(
                    children: [


                      /// Stake Now  Button
                      GradientButton(
                        text: "Stake Now",
                        trailingIcon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: screenHeight * 0.02,
                        ),
                        onPressed: () {
                          //  Add your action here
                          print("Button Pressed!");
                        },
                      ),

                      SizedBox(width: screenWidth * 0.03),
                      /// Buy ECM  Button Section
                      BuyEcm(
                        text: 'Buy ECM',
                        trailingIcon:  Icon(Icons.shopping_cart, color: Colors.white, size: screenHeight * 0.02),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.digitalModel);

                          print('Button tapped!');
                        },
                      ),

                    ],
                  ),
                ),


                SizedBox(height:screenHeight * 0.03),

                /// Staking History Section with Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      // border: Border.all(color: Colors.white60),
                      border: Border.all(color: Colors.white60, width: 0.5),

                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric( vertical: 15, horizontal: 5),
                          child:  Text(
                            'Staking History',
                            style: TextStyle(
                              fontSize: 20 * textScale,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oxanium',
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),

                        // Search bar
                        Align(
                          alignment: Alignment.center,

                          child: Container(

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.tealAccent),
                              borderRadius: BorderRadius.circular(8),

                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => _onSearchChanged(),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Search here...',
                                hintStyle: TextStyle(color: Colors.white60),
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search, color: Colors.white60),
                                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),

                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        // const SizedBox(height: 16),
                         SizedBox(height: screenHeight * 0.03),

                        LayoutBuilder(
                          builder: (context, constraints){
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Container(
                                      color: const Color(0xFF151A30),
                                      child: Row(
                                        children: [
                                          _stakingHistoryTableCell('SL', isHeader: true),
                                          _stakingHistoryTableCell('Date', isHeader: true),
                                          _stakingHistoryTableCell('Amount', isHeader: true),
                                          _stakingHistoryTableCell('ARR - Duration', isHeader: true),
                                          _stakingHistoryTableCell('Reward', isHeader: true),
                                          _stakingHistoryTableCell('Total Receive', isHeader: true),
                                          _stakingHistoryTableCell('Remaining?', isHeader: true),
                                          _stakingHistoryTableCell('Status', isHeader: true),
                                        ],
                                      ),
                                    ),
                                    if (_filteredData.isEmpty)
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(20),
                                        child: const Text(
                                          'No data found',
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                      )
                                    else
                                      ..._filteredData.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final data = entry.value;
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(color: Colors.white10),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  _stakingHistoryTableCell('${index + 1}'),
                                                  _stakingHistoryTableCell(data['date'] ?? ''),
                                                  _stakingHistoryTableCell(data['amount'] ?? ''),
                                                  _stakingHistoryTableCell(data['arrDuration'] ?? ''),
                                                  _stakingHistoryTableCell(data['reward'] ?? ''),
                                                  _stakingHistoryTableCell(data['totalReceive'] ?? ''),
                                                  _stakingHistoryTableCell(data['remaining'] ?? ''),
                                                  _stakingHistoryTableCell(data['status'] ?? ''),
                                                ],
                                              ),

                                            ),

                                          ],
                                        );
                                      }).toList(),
                                  ],
                                ),
                              ),
                            );

                          }
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget ecmInputSection(double textScale, double screenWidth, double screenHeight) {

    if(error != null){
      return Text('Error: $error', style: TextStyle(color: Colors.red));
    }

        return  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Min: 20 ECM',
                    style: TextStyle(
                      fontSize: 12 * textScale,
                      color: Colors.white60,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    'Max: 5000 ECM',
                    style: TextStyle(
                      fontSize: 12 * textScale,
                      color: Colors.white60,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.003),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  // Leading icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/ecm.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Input field
                  Expanded(
                    child: TextField(
                      controller: ecmAmountController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                           selectedPercentage = '';
                        });
                      },
                    ),
                  ),

                  // Trailing balance
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Text(
                        'Balance',
                        style: TextStyle(
                          fontSize: 12 * textScale,
                          color: Colors.white60,
                        ),
                      ),
                      Consumer<WalletViewModel>(
                        builder: (context, model, child){

                          if(model.isLoading || model.balance == null){
                            return  SizedBox(
                              width:  screenWidth * 0.055,
                              height:  screenHeight * 0.015,
                              child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white,
                              ),
                            );
                          }


                          return Text(
                            '${model.balance} ECM',
                            style: TextStyle(
                              fontSize: 12 * textScale,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }

                      ),

                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 3),
            // Percentage Buttons Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _percentageButton('25%', textScale),
                  _percentageButton('50%', textScale),
                  _percentageButton('75%', textScale),
                  _percentageButton('Max', textScale),
                ],
              ),
            ),
          ],
        );

  }
  Widget _percentageButton(String text, double textScale) {
    bool isSelected = selectedPercentage == text;

    final walletProvider = Provider.of<WalletViewModel>(context, listen: true);
    final balanceStr = walletProvider.balance;
    return InkWell(
      onTap: () {
        if(balanceStr != null){
          final balance = double.tryParse(balanceStr) ?? 0.0;

          double percentageValue = switch (text) {
            '25%' => balance * 0.25,
            '50%' => balance * 0.50,
            '75%' => balance * 0.75,
            'Max' => balance,
            _ => 0.0
          };

          ecmAmountController.text = percentageValue.toStringAsFixed(2);
          calculateRewards();

          setState(() {
            selectedPercentage = text;
          });

          print('Selected Percentage: $selectedPercentage');
        }

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(

          // No gradient here, we'll create it in the root container
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.all(2), // Creates space for the border effect
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white24,
                      width: 2,
                    ),
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [
                        Color(0xFF2D8EFF),
                        Color(0xFF2EE4A4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                  ),
                  child: isSelected
                      ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14 * textScale,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _ecmAmountRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.greenAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget validitySection(double textScale, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current: 0 ECM',
                style: TextStyle(
                  fontSize: 12 * textScale,
                  color: Colors.white60,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                'Remaining: 0 ECM',
                style: TextStyle(
                  fontSize: 12 * textScale,
                  color: Colors.white60,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Input Field with Leading Icon and Trailing Balance
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.003),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              // Leading icon
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/timer.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Input field
              Expanded(
                child: TextField(
                  controller: _dayController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                     hintText: _dayController.text.isEmpty ? (selectedDay.replaceAll('D', '')) : null,
                      hintStyle: const TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      selectedDay = '${value}D';
                      selectedDay = '';
                    });
                  },
                  readOnly: true,
                ),
              ),

              // Trailing balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Days',
                    style: TextStyle(
                      fontSize: 12 * textScale,
                      color: Colors.white,
                    ),
                  ),
                 ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 2),

        // Percentage Buttons Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              _validityButton('7D', textScale),
              _validityButton('30D', textScale),
              _validityButton('90D', textScale),
              _validityButton('180D', textScale),
              _validityButton('365D', textScale),
            ],
          ),
        ),
      ],
    );
  }
  Widget _validityButton(String text, double textScale) {
    bool isSelected = selectedDay == text;

    return InkWell(
      onTap: () {

        setState(() {
          selectedDay = text;
        });
        calculateRewards();
        print('Selected Percentage: $selectedDay');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.all(2), // Creates space for the border effect
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white24,
                      width: 2,
                    ),
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [
                        Color(0xFF2D8EFF),
                        Color(0xFF2EE4A4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                  ),
                  child: isSelected
                      ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14 * textScale,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _ecmValidityRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.greenAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget lockOverViewSection(double textScale, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // Responsive padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Lock Overview',
                style: TextStyle(
                  fontSize: 14 * textScale, // Slightly bigger and responsive
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01), // Responsive vertical space

        // Input Field with Leading Icon and Text
        Container(
          width: double.infinity, // Full width
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.01,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2D8EFF),
                Color(0xFF2EE4A4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading icon
                Container(
                  width: screenWidth * 0.08,
                  height: screenWidth * 0.08,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/ecm.png',
                      width: screenWidth * 0.05,
                      height: screenWidth * 0.05,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),

                // Main Text
                Text(
                  lockOverviewText.isNotEmpty ? lockOverviewText : "Enter ECM to Stake",
                  style: TextStyle(
                    fontSize: 18 * textScale, // Responsive text size
                    color: Colors.white,
                    // fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }



  Widget _stakingHistoryTableCell(String text, {bool isHeader = false}) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }



  void _loadDummyData(){
    _stakingData = [
      {
        'date': '2024-04-01',
        'amount': '100',
        'arrDuration': '10% - 30d',
        'reward': '10',
        'totalReceive': '110',
        'remaining': '0',
        'status': 'Completed',
      },
      {
        'date': '2024-03-20',
        'amount': '200',
        'arrDuration': '12% - 60d',
        'reward': '24',
        'totalReceive': '224',
        'remaining': '10',
        'status': 'Active',
      },
      {
        'date': '2024-03-20',
        'amount': '200',
        'arrDuration': '12% - 60d',
        'reward': '24',
        'totalReceive': '224',
        'remaining': '10',
        'status': 'Active',
      },
      {
        'date': '2024-03-20',
        'amount': '200',
        'arrDuration': '12% - 60d',
        'reward': '24',
        'totalReceive': '224',
        'remaining': '10',
        'status': 'Active',
      },
      {
        'date': '2024-03-20',
        'amount': '200',
        'arrDuration': '12% - 60d',
        'reward': '24',
        'totalReceive': '224',
        'remaining': '10',
        'status': 'Active',
      },

    ];
  }
}


// if(balanceStr != null){
//   final balance = double.tryParse(balanceStr) ?? 0.0;
//   double percentageValue = 0.0;
//
//   switch(text){
//     case '25%':
//       percentageValue = balance * 0.25;
//       break;
//     case '50%':
//       percentageValue =  balance * 0.50;
//       break;
//     case '75%':
//       percentageValue = balance *  0.75;
//       break;
//     case 'Max':
//       percentageValue = balance;
//       break;
//   }
//
//
//
//   ecmAmountController.text = percentageValue.toStringAsFixed(2);
//   calculateRewards();
// }
// setState(() {
//   selectedPercentage = text;
// });
// print('Selected Percentage: $selectedPercentage');