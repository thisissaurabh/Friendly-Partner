import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friendly_partner/app/widgets/custom_appbar.dart';
import 'package:friendly_partner/app/widgets/custom_button.dart';
import 'package:friendly_partner/app/widgets/custom_snackbar.dart';
import 'package:friendly_partner/controllers/helper_controller.dart';
import 'package:friendly_partner/controllers/whole_seller_controller.dart';
import 'package:friendly_partner/data/repo/whole_seller.dart';
import 'package:friendly_partner/utils/dimensions.dart';
import 'package:friendly_partner/utils/styles.dart';
import 'package:friendly_partner/utils/theme/light_theme.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:get/get.dart';

import '../../../utils/sizeboxes.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/decorations.dart';
import '../../widgets/multi_select_dropdown.dart';
class AddProducts extends StatelessWidget {
   AddProducts({super.key});


  final formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productDescController = TextEditingController();
   final productShortDescController = TextEditingController();
   final brandController = TextEditingController();
   final codeController = TextEditingController();
   final colorController = TextEditingController();
   final priceController = TextEditingController();
   final discountedPriceController = TextEditingController();
   final quantityController = TextEditingController();
   final minimumOrderQuantityController = TextEditingController();
   final metaTitleController = TextEditingController();
   final metaDescriptionController = TextEditingController();
  final RxString gender = 'male'.obs;
   final RxnInt selectedCategory = RxnInt();
   final RxnInt selectedSubCategory = RxnInt();
   final RxnInt selectedBrand = RxnInt();

   final List<String> colorOptions = ['Red', 'Green', 'Blue', 'Black', 'White'];
   final RxList<String> selectedColors = <String>[].obs;
   final RxList<String> selectedItems = RxList<String>([]);
   @override
  Widget build(BuildContext context) {
    final repo = Get.put(WholeSellerRepo(apiClient: Get.find()));
    final controller = Get.put(WholeSellerController(wholeSellerRepo: Get.find()));
    final helpControl = Get.put(HelperController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCategoryListApi();
      controller.getBrandListApi();
      helpControl.generateProductCode();

    });
    return SafeArea(
      child: Form(
        key: formKey,
        child: Scaffold(
          appBar: CustomBackAppBar(title: "Add Product",isBackButtonExist: true,),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                children: [
               GetBuilder<WholeSellerController>(builder: (wholeSellerControl) {
                 return GetBuilder<HelperController>(builder: (helpControl) {
                   WidgetsBinding.instance.addPostFrameCallback((_) {
                     codeController.text = helpControl.generatedProductCode;

                   });

                   return  Column(
                     children: [
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           Center(
                             child: Column(
                               children: [
                                 SizedBox(
                                   height: 200,
                                   width: 200,
                                   child: Stack(
                                     children: [
                                       Positioned(
                                         bottom: 0,
                                         left: 0,
                                         right: 0,
                                         child: Center(
                                           child: Stack(
                                             children: [
                                               Container(
                                                 height: 200,
                                                 width: 200,
                                                 clipBehavior: Clip.hardEdge,
                                                 decoration: BoxDecoration(
                                                   // shape: BoxShape.circle,
                                                   border: Border.all(
                                                     width: 0.5,
                                                     color: Theme.of(context)
                                                         .primaryColor
                                                         .withOpacity(0.40),
                                                   ),
                                                   color: Theme.of(context)
                                                       .primaryColor
                                                       .withOpacity(0.1),
                                                 ),
                                                 // alignment: Alignment.center,
                                                 child: helpControl.pickedPhotoImage !=
                                                     null
                                                     ? Image.file(
                                                   File(
                                                     helpControl
                                                         .pickedPhotoImage!.path,
                                                   ),
                                                   height: 180,
                                                   width: 180,
                                                   fit: BoxFit.cover,
                                                 )
                                                     : Stack(
                                                   children: [
                                                     Container(
                                                         height: 200,
                                                         width: 200,
                                                         clipBehavior:
                                                         Clip.hardEdge,
                                                         decoration:
                                                         BoxDecoration(
                                                           // shape:
                                                           // BoxShape.circle,
                                                           color: Theme.of(
                                                               context)
                                                               .primaryColor
                                                               .withOpacity(
                                                               0.1),
                                                         ),
                                                         child: Icon(
                                                             Icons.person)),
                                                     // Image.asset(Images.profilePlaceholder,)
                                                   ],
                                                 ),
                                               ),
                                               Positioned(
                                                 bottom: 0,
                                                 right: 0,
                                                 top: 0,
                                                 left: 0,
                                                 child: InkWell(
                                                   onTap: (){
                                                     helpControl.pickPhotoImage(isRemove: false);
                                                   },
                                                   child: Container(
                                                     decoration: BoxDecoration(
                                                       color: Colors.black
                                                           .withOpacity(0.3),
                                                       // shape: BoxShape.circle,
                                                       border: Border.all(
                                                           width: 1,
                                                           color: Theme.of(context)
                                                               .primaryColor),
                                                     ),
                                                     child: Container(
                                                       margin:
                                                       const EdgeInsets.all(25),
                                                       decoration: BoxDecoration(
                                                         border: Border.all(
                                                             width: 2,
                                                             color: Colors.white),
                                                         shape: BoxShape.circle,
                                                       ),
                                                       child: const Icon(
                                                           Icons.camera_alt,
                                                           color: Colors.white),
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                                 sizedBox10(),
                                 Text("Add Product Image"),
                                 Text("500x500",style: robotoRegular.copyWith(
                                     color: redColor
                                 ),),
                               ],
                             ),
                           ),

                         ],
                       ),
                       sizedBox10(),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           helpControl.pickedAdditionalImages!.isEmpty ?
                               SizedBox() :

                           SizedBox(
                             height: 100,
                             child: ListView.builder(
                               scrollDirection: Axis.horizontal,
                               itemCount: helpControl.pickedAdditionalImages?.length ?? 0,
                               itemBuilder: (_, index) {
                                 final image = helpControl.pickedAdditionalImages![index];
                                 return Padding(
                                   padding: const EdgeInsets.only(right: 8.0),
                                   child: ClipRRect(
                                     borderRadius: BorderRadius.circular(8),
                                     child: Image.file(
                                       File(image.path),
                                       height: 100,
                                       width: 100,
                                       fit: BoxFit.cover,
                                     ),
                                   ),
                                 );
                               },
                             ),
                           ),
                           Center(
                             child: TextButton.icon(
                               onPressed: helpControl.pickMultipleAdditionImages,
                               icon: const Icon(Icons.add_a_photo),
                               label: const Text("Add More Product Images"),
                             ),
                           ),
                           Center(child: Text("500x500", style: robotoRegular.copyWith(color: redColor))),
                         ],
                       ),

                       sizedBoxDefault(),
                       sizedBoxDefault(),
                       CustomTextField(
                         capitalization: TextCapitalization.words,
                         showTitle: true,
                         hintText: "Product Name",
                         controller: productNameController,
                         validation: helpControl.validate,
                       ),

                       sizedBoxDefault(),
                       CustomTextField(
                         capitalization: TextCapitalization.words,
                         showTitle: true,
                         hintText: "Product Description",
                         controller: productDescController,
                         validation: helpControl.validate,
                       ),
                       sizedBoxDefault(),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             "Category",
                                                 ),
                                                sizedBox10(),
                                                 DropdownButtonFormField<int>(
                             decoration: DropDownDecoration(),
                             value: selectedCategory.value,
                                                   validator: (value) {
                                                     if (value == null) {
                                                       return 'Please Category';
                                                     }
                                                     return null;
                                                   },
                             hint:  Text("Select Category",
                             style: TextStyle(
                               fontSize: 14,
                               color: Theme.of(context)
                                   .disabledColor
                                   .withOpacity(0.60),
                             ),),
                             items: (wholeSellerControl.categoryList ?? [])
                                 .map<DropdownMenuItem<int>>((category) {
                               return DropdownMenuItem<int>(
                                 value: category['id'],
                                 child: Text(category['name']),
                               );
                             }).toList(),
                             onChanged: (value) {
                               selectedCategory.value = value;
                               print('Category ID : ${selectedCategory.value}');
                               controller.getSubCategoryListApi(categoryId: selectedCategory.toString());
                             },
                                                 ),
                          ],
                        ),

                       sizedBoxDefault(),
                       Column(crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             "Sub Category",
                           ),
                           sizedBox10(),
                           DropdownButtonFormField<int>(
                             decoration: DropDownDecoration(),
                             value: selectedSubCategory.value,
                             validator: (value) {
                               if (value == null) {
                                 return 'Please select a Sub Category';
                               }
                               return null;
                             },
                             hint: Text("Select Sub Category",style: TextStyle(
                               fontSize: 14,
                               color: Theme.of(context)
                                   .disabledColor
                                   .withOpacity(0.60),
                             ),),
                             items: (wholeSellerControl.subCategoryList ?? [])
                                 .map<DropdownMenuItem<int>>((category) {
                               return DropdownMenuItem<int>(
                                 value: category['id'],
                                 child: Text(category['name']),
                               );
                             }).toList(),
                             onChanged: (value) {
                               selectedSubCategory.value = value;
                             },
                           ),
                         ],
                       ),
                       sizedBoxDefault(),
                       Column(crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             "Brand",
                           ),
                           sizedBox10(),
                           DropdownButtonFormField<int>(
                             decoration: DropDownDecoration(),
                             value: selectedBrand.value,
                             validator: (value) {
                               if (value == null) {
                                 return 'Select Brand';
                               }
                               return null;
                             },
                             hint:  Text("Select Brand",
                               style: TextStyle(
                                 fontSize: 14,
                                 color: Theme.of(context)
                                     .disabledColor
                                     .withOpacity(0.60),
                               ),),
                             items: (wholeSellerControl.brandList ?? [])
                                 .map<DropdownMenuItem<int>>((category) {
                               return DropdownMenuItem<int>(
                                 value: category['id'],
                                 child: Text(category['name']),
                               );
                             }).toList(),
                             onChanged: (value) {
                               selectedBrand.value = value;
                               print('Brand ID : ${selectedBrand.value}');
                             },
                           ),
                         ],
                       ),
                       sizedBoxDefault(),
                       CustomTextField(
                         capitalization: TextCapitalization.words,
                         showTitle: true,
                         hintText: "Product Short Description",
                         controller: productShortDescController,
                         validation: helpControl.validate,
                       ),
                       sizedBoxDefault(),
                       CustomTextField(
                         inputType: TextInputType.number,
                         showTitle: true,
                         hintText: "Product SKU",
                         readOnly: true,
                         controller: codeController,
                         validation: helpControl.validate,
                       ),
                       sizedBoxDefault(),
                       Row(
                         children: [

                           Expanded(
                             child: CustomTextField(
                               capitalization: TextCapitalization.words,
                               showTitle: true,
                               hintText: "Price",
                               inputType: TextInputType.number,
                               controller: priceController,
                               validation: helpControl.validate,
                             ),
                           ),
                           sizedBoxW10(),
                           Expanded(
                             child: CustomTextField(
                               capitalization: TextCapitalization.words,
                               showTitle: true,
                               hintText: "Discounted Price",
                               inputType: TextInputType.number,
                               controller: discountedPriceController,
                               validation: helpControl.validate,
                             ),
                           ),
                         ],
                       ),
                       sizedBoxDefault(),
                       MultiSelectDropdown(
                         options: helpControl.colors,

                         selectedItems: selectedItems,
                         hintText: "Select Colors",
                       ),



                       sizedBoxDefault(),
                       CustomTextField(
                         capitalization: TextCapitalization.words,
                         showTitle: true,
                         hintText: "Quantity",
                         inputType: TextInputType.number,
                         controller: quantityController,
                         validation: helpControl.validate,
                       ),
                       sizedBoxDefault(),
                       CustomTextField(
                         capitalization: TextCapitalization.words,
                         showTitle: true,
                         hintText: "Minimum Order Quantity",
                         inputType: TextInputType.number,
                         controller: minimumOrderQuantityController,
                         validation: helpControl.validate,
                       ),
                       // sizedBoxDefault(),
                       // CustomTextField(
                       //   capitalization: TextCapitalization.words,
                       //   showTitle: true,
                       //   hintText: "Meta Title",
                       //   controller: metaTitleController,
                       //   validation: helpControl.validate,
                       // ),
                       // sizedBoxDefault(),
                       // CustomTextField(
                       //   capitalization: TextCapitalization.words,
                       //   showTitle: true,
                       //   hintText: "Meta Description",
                       //   controller: metaDescriptionController,
                       //   validation: helpControl.validate,
                       // ),
                       sizedBox30(),

                       CustomButtonWidget(buttonText: "Add Product",
                         onPressed: () {
                         print(selectedColors);
                            if(helpControl.pickedPhotoImage == null || helpControl.pickedPhotoImage!.path.isEmpty ||
                                helpControl.pickedAdditionalImages == null || helpControl.pickedAdditionalImages!.isEmpty)
                            {
                              showCustomSnackBar(context, "Please Add Product Images.");
                            } else {
       if(formKey.currentState!.validate()) {

       wholeSellerControl.addProduct(
         name: productNameController.text.trim(),
         description: productNameController.text.trim(),
         shortDescription: productShortDescController.text.trim(),
         category:selectedCategory.string,
         subCategory: [selectedSubCategory.value!],
         // subCategory: selectedSubCategory.toString(),
         brand: selectedBrand.toString(),
         code: codeController.text.trim(),
         // color: colorController.text.trim(),
         price: priceController.text.trim(),
         discountPrice: discountedPriceController.text.trim(),
         quantity: quantityController.text.trim(),
         minOrderQuantity: minimumOrderQuantityController.text.trim(),
         metaTitle: "N/A",
         metaDescription:"N/A",
         // metaTitle: metaTitleController.text.trim(),
         // metaDescription: metaDescriptionController.text.trim(),
         thumbnail:
           helpControl
               .pickedPhotoImage !=
           null
           ? File(
           helpControl.pickedPhotoImage!.path)
                           : null,
         additionThumbnails: helpControl.pickedAdditionalImages?.map((x) => File(x.path)).toList(),
         colorList:selectedItems,
       );
     }
                            }
                         },
                       )


                     ],
                   );
                 });
               })



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
