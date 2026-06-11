import '../models/diet_day.dart';

class DietData {
  static List<DietDay> getAllDays() {
    return const [
      // ============================================================
      // DAY 1
      // ============================================================
      DietDay(
        dayNumber: 1,
        standardMeals: [
          Meal(
            name: 'Scrambled Eggs & Toast',
            calories: 350,
            description:
                'Fluffy scrambled eggs served on whole grain toast with a side of fresh herbs.',
            ingredients: [
              'Eggs',
              'Whole grain bread',
              'Butter',
              'Salt & pepper',
              'Fresh chives',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Greek Yogurt & Berries',
            calories: 150,
            description:
                'Creamy Greek yogurt topped with a medley of fresh seasonal berries.',
            ingredients: [
              'Greek yogurt',
              'Blueberries',
              'Strawberries',
              'Honey',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Grilled Chicken Salad',
            calories: 450,
            description:
                'Tender grilled chicken breast over a bed of mixed greens with balsamic vinaigrette.',
            ingredients: [
              'Chicken breast',
              'Mixed greens',
              'Cherry tomatoes',
              'Cucumber',
              'Balsamic vinaigrette',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Baked Salmon & Veggies',
            calories: 500,
            description:
                'Oven-baked salmon fillet with roasted seasonal vegetables and a squeeze of lemon.',
            ingredients: [
              'Salmon fillet',
              'Broccoli',
              'Zucchini',
              'Olive oil',
              'Lemon',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Oatmeal & Banana',
            calories: 320,
            description:
                'Warm rolled oats topped with sliced banana and a drizzle of maple syrup.',
            ingredients: [
              'Rolled oats',
              'Banana',
              'Maple syrup',
              'Almond milk',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Hummus & Carrots',
            calories: 130,
            description:
                'Smooth homemade hummus served with crunchy baby carrot sticks.',
            ingredients: [
              'Chickpeas',
              'Tahini',
              'Carrots',
              'Lemon juice',
              'Garlic',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Quinoa Buddha Bowl',
            calories: 420,
            description:
                'Nutritious quinoa bowl loaded with roasted vegetables, avocado, and tahini dressing.',
            ingredients: [
              'Quinoa',
              'Roasted sweet potato',
              'Avocado',
              'Chickpeas',
              'Tahini dressing',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Tofu Stir Fry',
            calories: 450,
            description:
                'Crispy pan-fried tofu tossed with colorful vegetables in a savory soy-ginger sauce.',
            ingredients: [
              'Firm tofu',
              'Bell peppers',
              'Broccoli',
              'Soy sauce',
              'Ginger',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 2
      // ============================================================
      DietDay(
        dayNumber: 2,
        standardMeals: [
          Meal(
            name: 'Protein Pancakes',
            calories: 400,
            description:
                'Fluffy pancakes made with protein powder and topped with fresh berries.',
            ingredients: [
              'Protein powder',
              'Oat flour',
              'Eggs',
              'Banana',
              'Mixed berries',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Mixed Nuts',
            calories: 180,
            description:
                'A satisfying handful of lightly salted premium mixed nuts.',
            ingredients: [
              'Almonds',
              'Cashews',
              'Walnuts',
              'Sea salt',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Turkey Wrap',
            calories: 420,
            description:
                'Sliced turkey breast wrapped in a whole wheat tortilla with fresh veggies and mustard.',
            ingredients: [
              'Turkey breast',
              'Whole wheat tortilla',
              'Lettuce',
              'Tomato',
              'Dijon mustard',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Lean Beef Stir Fry',
            calories: 520,
            description:
                'Tender strips of lean beef stir-fried with vegetables in a rich oyster sauce.',
            ingredients: [
              'Lean beef strips',
              'Bell peppers',
              'Snow peas',
              'Oyster sauce',
              'Brown rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Smoothie Bowl',
            calories: 350,
            description:
                'Thick blended smoothie bowl topped with granola, coconut flakes, and fresh fruit.',
            ingredients: [
              'Frozen acai',
              'Banana',
              'Granola',
              'Coconut flakes',
              'Chia seeds',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Apple & Peanut Butter',
            calories: 200,
            description:
                'Crisp apple slices served with creamy natural peanut butter for dipping.',
            ingredients: [
              'Apple',
              'Natural peanut butter',
              'Cinnamon',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Falafel Pita',
            calories: 430,
            description:
                'Crispy baked falafel tucked into warm pita bread with pickled veggies and tahini.',
            ingredients: [
              'Falafel',
              'Pita bread',
              'Pickled turnip',
              'Lettuce',
              'Tahini sauce',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Lentil Curry',
            calories: 470,
            description:
                'Hearty red lentil curry simmered in a fragrant tomato and coconut sauce with basmati rice.',
            ingredients: [
              'Red lentils',
              'Coconut milk',
              'Tomatoes',
              'Curry spices',
              'Basmati rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 3
      // ============================================================
      DietDay(
        dayNumber: 3,
        standardMeals: [
          Meal(
            name: 'Avocado Toast with Egg',
            calories: 380,
            description:
                'Smashed avocado on sourdough toast topped with a perfectly poached egg.',
            ingredients: [
              'Avocado',
              'Sourdough bread',
              'Egg',
              'Red pepper flakes',
              'Lemon juice',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Cottage Cheese & Fruit',
            calories: 160,
            description:
                'Low-fat cottage cheese paired with chunks of sweet pineapple and peach.',
            ingredients: [
              'Cottage cheese',
              'Pineapple',
              'Peach',
              'Mint',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Tuna Salad Sandwich',
            calories: 440,
            description:
                'Classic tuna salad with celery and light mayo on multigrain bread.',
            ingredients: [
              'Canned tuna',
              'Celery',
              'Light mayo',
              'Multigrain bread',
              'Lettuce',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Chicken Breast & Sweet Potato',
            calories: 510,
            description:
                'Herb-seasoned chicken breast served alongside roasted sweet potato wedges.',
            ingredients: [
              'Chicken breast',
              'Sweet potato',
              'Rosemary',
              'Olive oil',
              'Green beans',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Chia Pudding & Mango',
            calories: 300,
            description:
                'Overnight chia pudding made with coconut milk and topped with fresh mango cubes.',
            ingredients: [
              'Chia seeds',
              'Coconut milk',
              'Mango',
              'Honey',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Trail Mix',
            calories: 190,
            description:
                'A wholesome trail mix of dried fruits, seeds, and dark chocolate chips.',
            ingredients: [
              'Almonds',
              'Dried cranberries',
              'Pumpkin seeds',
              'Dark chocolate chips',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Mediterranean Wrap',
            calories: 400,
            description:
                'Whole wheat wrap filled with roasted red peppers, feta cheese, olives, and greens.',
            ingredients: [
              'Whole wheat wrap',
              'Roasted red peppers',
              'Feta cheese',
              'Kalamata olives',
              'Spinach',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Chickpea Tikka Masala',
            calories: 460,
            description:
                'Tender chickpeas in a rich and creamy tikka masala sauce served with fluffy rice.',
            ingredients: [
              'Chickpeas',
              'Tikka masala sauce',
              'Basmati rice',
              'Cream',
              'Cilantro',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 4
      // ============================================================
      DietDay(
        dayNumber: 4,
        standardMeals: [
          Meal(
            name: 'Omelette with Veggies',
            calories: 360,
            description:
                'A fluffy three-egg omelette stuffed with sauteed mushrooms, peppers, and onions.',
            ingredients: [
              'Eggs',
              'Mushrooms',
              'Bell peppers',
              'Onions',
              'Cheddar cheese',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Protein Bar',
            calories: 200,
            description:
                'A chocolate chip protein bar packed with whey protein for sustained energy.',
            ingredients: [
              'Whey protein',
              'Oats',
              'Chocolate chips',
              'Honey',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Shrimp Tacos',
            calories: 460,
            description:
                'Grilled shrimp tacos in corn tortillas topped with mango salsa and lime crema.',
            ingredients: [
              'Shrimp',
              'Corn tortillas',
              'Mango salsa',
              'Lime crema',
              'Cabbage slaw',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Pork Tenderloin & Rice',
            calories: 530,
            description:
                'Herb-rubbed pork tenderloin sliced and served with steamed jasmine rice and gravy.',
            ingredients: [
              'Pork tenderloin',
              'Jasmine rice',
              'Fresh herbs',
              'Garlic',
              'Pan gravy',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Banana Pancakes',
            calories: 340,
            description:
                'Light and fluffy pancakes made with mashed banana and a hint of vanilla.',
            ingredients: [
              'Banana',
              'Flour',
              'Eggs',
              'Vanilla extract',
              'Maple syrup',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Edamame',
            calories: 150,
            description:
                'Steamed edamame pods sprinkled with flaky sea salt for a protein-rich snack.',
            ingredients: [
              'Edamame',
              'Sea salt',
              'Lemon zest',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Black Bean Burrito Bowl',
            calories: 440,
            description:
                'Seasoned black beans over cilantro-lime rice with corn, salsa, and guacamole.',
            ingredients: [
              'Black beans',
              'Cilantro-lime rice',
              'Corn',
              'Salsa',
              'Guacamole',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Eggplant Parmesan',
            calories: 480,
            description:
                'Breaded eggplant slices baked with marinara sauce and melted mozzarella cheese.',
            ingredients: [
              'Eggplant',
              'Marinara sauce',
              'Mozzarella',
              'Breadcrumbs',
              'Parmesan',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 5
      // ============================================================
      DietDay(
        dayNumber: 5,
        standardMeals: [
          Meal(
            name: 'Breakfast Burrito',
            calories: 420,
            description:
                'A hearty flour tortilla filled with scrambled eggs, cheese, salsa, and sausage.',
            ingredients: [
              'Flour tortilla',
              'Eggs',
              'Cheddar cheese',
              'Salsa',
              'Breakfast sausage',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Beef Jerky & Cheese',
            calories: 170,
            description:
                'Savory beef jerky paired with a stick of sharp cheddar cheese.',
            ingredients: [
              'Beef jerky',
              'Cheddar cheese',
              'Crackers',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Grilled Fish & Quinoa',
            calories: 450,
            description:
                'Lightly seasoned grilled white fish served over a bed of herbed quinoa.',
            ingredients: [
              'White fish fillet',
              'Quinoa',
              'Lemon',
              'Fresh dill',
              'Asparagus',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Chicken Parmesan',
            calories: 540,
            description:
                'Crispy breaded chicken cutlet topped with marinara and melted mozzarella over pasta.',
            ingredients: [
              'Chicken breast',
              'Marinara sauce',
              'Mozzarella',
              'Spaghetti',
              'Parmesan',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Granola & Yogurt',
            calories: 360,
            description:
                'Crunchy homemade granola layered with thick Greek yogurt and a drizzle of honey.',
            ingredients: [
              'Granola',
              'Greek yogurt',
              'Honey',
              'Sliced almonds',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Roasted Chickpeas',
            calories: 140,
            description:
                'Crispy oven-roasted chickpeas seasoned with smoked paprika and cumin.',
            ingredients: [
              'Chickpeas',
              'Smoked paprika',
              'Cumin',
              'Olive oil',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Veggie Sushi Bowl',
            calories: 410,
            description:
                'Deconstructed sushi bowl with seasoned rice, avocado, cucumber, and pickled ginger.',
            ingredients: [
              'Sushi rice',
              'Avocado',
              'Cucumber',
              'Nori',
              'Pickled ginger',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Mushroom Risotto',
            calories: 470,
            description:
                'Creamy arborio rice slowly cooked with wild mushrooms and finished with parmesan.',
            ingredients: [
              'Arborio rice',
              'Wild mushrooms',
              'Vegetable broth',
              'Parmesan',
              'White wine',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 6
      // ============================================================
      DietDay(
        dayNumber: 6,
        standardMeals: [
          Meal(
            name: 'French Toast with Berries',
            calories: 390,
            description:
                'Golden French toast made with brioche bread, served with fresh mixed berries.',
            ingredients: [
              'Brioche bread',
              'Eggs',
              'Milk',
              'Cinnamon',
              'Mixed berries',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Almonds & Dark Chocolate',
            calories: 180,
            description:
                'A balanced snack of roasted almonds paired with squares of rich dark chocolate.',
            ingredients: [
              'Roasted almonds',
              'Dark chocolate',
              'Sea salt',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Chicken Caesar Wrap',
            calories: 430,
            description:
                'Grilled chicken with romaine lettuce and Caesar dressing in a spinach wrap.',
            ingredients: [
              'Chicken breast',
              'Romaine lettuce',
              'Caesar dressing',
              'Spinach wrap',
              'Parmesan',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Beef Tacos',
            calories: 520,
            description:
                'Seasoned ground beef tacos with fresh pico de gallo, cheese, and sour cream.',
            ingredients: [
              'Ground beef',
              'Corn tortillas',
              'Pico de gallo',
              'Cheddar cheese',
              'Sour cream',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Acai Bowl',
            calories: 340,
            description:
                'Blended acai berry base topped with sliced banana, granola, and coconut flakes.',
            ingredients: [
              'Acai puree',
              'Banana',
              'Granola',
              'Coconut flakes',
              'Honey',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Rice Cakes & Almond Butter',
            calories: 170,
            description:
                'Crispy rice cakes spread with creamy almond butter and a pinch of cinnamon.',
            ingredients: [
              'Rice cakes',
              'Almond butter',
              'Cinnamon',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Spinach & Feta Quiche',
            calories: 420,
            description:
                'A savory quiche filled with fresh spinach, crumbled feta, and sun-dried tomatoes.',
            ingredients: [
              'Pie crust',
              'Spinach',
              'Feta cheese',
              'Eggs',
              'Sun-dried tomatoes',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Vegetable Pad Thai',
            calories: 460,
            description:
                'Stir-fried rice noodles tossed with tofu, bean sprouts, and tangy tamarind sauce.',
            ingredients: [
              'Rice noodles',
              'Tofu',
              'Bean sprouts',
              'Tamarind sauce',
              'Crushed peanuts',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 7
      // ============================================================
      DietDay(
        dayNumber: 7,
        standardMeals: [
          Meal(
            name: 'Smoked Salmon Bagel',
            calories: 410,
            description:
                'A toasted everything bagel layered with cream cheese, smoked salmon, and capers.',
            ingredients: [
              'Everything bagel',
              'Cream cheese',
              'Smoked salmon',
              'Capers',
              'Red onion',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Hard Boiled Eggs',
            calories: 140,
            description:
                'Two perfectly hard boiled eggs seasoned with a pinch of salt and pepper.',
            ingredients: [
              'Eggs',
              'Salt',
              'Pepper',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Chicken Pho',
            calories: 440,
            description:
                'Fragrant Vietnamese pho with tender chicken, rice noodles, and fresh herbs.',
            ingredients: [
              'Chicken',
              'Rice noodles',
              'Star anise broth',
              'Bean sprouts',
              'Fresh basil',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Grilled Steak & Salad',
            calories: 530,
            description:
                'Juicy grilled sirloin steak sliced over a fresh arugula salad with vinaigrette.',
            ingredients: [
              'Sirloin steak',
              'Arugula',
              'Cherry tomatoes',
              'Red onion',
              'Balsamic vinaigrette',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Berry Overnight Oats',
            calories: 330,
            description:
                'Creamy overnight oats soaked in almond milk and layered with mixed berries.',
            ingredients: [
              'Rolled oats',
              'Almond milk',
              'Mixed berries',
              'Chia seeds',
              'Honey',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Fruit Salad',
            calories: 120,
            description:
                'A refreshing medley of seasonal fresh fruits with a squeeze of lime.',
            ingredients: [
              'Watermelon',
              'Grapes',
              'Kiwi',
              'Lime juice',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Veggie Burger & Sweet Potato Fries',
            calories: 450,
            description:
                'A black bean veggie burger on a whole wheat bun with baked sweet potato fries.',
            ingredients: [
              'Black bean patty',
              'Whole wheat bun',
              'Sweet potato fries',
              'Lettuce',
              'Tomato',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Palak Paneer with Naan',
            calories: 490,
            description:
                'Cubes of paneer cheese in a creamy spinach gravy served with warm garlic naan.',
            ingredients: [
              'Paneer',
              'Spinach',
              'Cream',
              'Garlic naan',
              'Spices',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 8
      // ============================================================
      DietDay(
        dayNumber: 8,
        standardMeals: [
          Meal(
            name: 'Egg Benedict',
            calories: 420,
            description:
                'Poached eggs on an English muffin with Canadian bacon and hollandaise sauce.',
            ingredients: [
              'Eggs',
              'English muffin',
              'Canadian bacon',
              'Hollandaise sauce',
              'Chives',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Protein Shake',
            calories: 170,
            description:
                'A quick protein shake blended with whey protein, banana, and almond milk.',
            ingredients: [
              'Whey protein',
              'Banana',
              'Almond milk',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Teriyaki Chicken Bowl',
            calories: 450,
            description:
                'Glazed teriyaki chicken over steamed rice with stir-fried vegetables.',
            ingredients: [
              'Chicken thigh',
              'Teriyaki sauce',
              'Steamed rice',
              'Broccoli',
              'Carrots',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Baked Cod & Asparagus',
            calories: 480,
            description:
                'Flaky baked cod with a lemon-herb crust served alongside roasted asparagus.',
            ingredients: [
              'Cod fillet',
              'Asparagus',
              'Lemon',
              'Breadcrumbs',
              'Olive oil',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Whole Wheat Waffles & Maple',
            calories: 350,
            description:
                'Crispy whole wheat waffles drizzled with pure maple syrup and a dusting of powdered sugar.',
            ingredients: [
              'Whole wheat waffle mix',
              'Eggs',
              'Maple syrup',
              'Butter',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Celery & Peanut Butter',
            calories: 160,
            description:
                'Crunchy celery sticks filled with natural peanut butter for a classic snack.',
            ingredients: [
              'Celery',
              'Peanut butter',
              'Raisins',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Greek Salad with Falafel',
            calories: 430,
            description:
                'A traditional Greek salad with cucumbers, olives, and feta topped with warm falafel.',
            ingredients: [
              'Falafel',
              'Cucumber',
              'Kalamata olives',
              'Feta cheese',
              'Red onion',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Stuffed Bell Peppers',
            calories: 470,
            description:
                'Bell peppers stuffed with seasoned rice, black beans, corn, and melted cheese.',
            ingredients: [
              'Bell peppers',
              'Rice',
              'Black beans',
              'Corn',
              'Cheese',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 9
      // ============================================================
      DietDay(
        dayNumber: 9,
        standardMeals: [
          Meal(
            name: 'Spinach & Mushroom Omelette',
            calories: 370,
            description:
                'A golden omelette filled with sauteed spinach, mushrooms, and Swiss cheese.',
            ingredients: [
              'Eggs',
              'Spinach',
              'Mushrooms',
              'Swiss cheese',
              'Butter',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Greek Yogurt Parfait',
            calories: 180,
            description:
                'Layers of Greek yogurt, crunchy granola, and seasonal fruit in a glass.',
            ingredients: [
              'Greek yogurt',
              'Granola',
              'Blueberries',
              'Honey',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'BBQ Chicken Sandwich',
            calories: 460,
            description:
                'Shredded BBQ chicken piled on a toasted brioche bun with coleslaw.',
            ingredients: [
              'Shredded chicken',
              'BBQ sauce',
              'Brioche bun',
              'Coleslaw',
              'Pickles',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Salmon Teriyaki & Rice',
            calories: 520,
            description:
                'Pan-seared salmon glazed in teriyaki sauce served with steamed jasmine rice.',
            ingredients: [
              'Salmon fillet',
              'Teriyaki sauce',
              'Jasmine rice',
              'Sesame seeds',
              'Steamed bok choy',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Avocado Smoothie',
            calories: 340,
            description:
                'A creamy avocado smoothie blended with spinach, banana, and coconut water.',
            ingredients: [
              'Avocado',
              'Spinach',
              'Banana',
              'Coconut water',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Mixed Seed Bar',
            calories: 170,
            description:
                'A crunchy seed bar made with sunflower, pumpkin, and flax seeds bound with honey.',
            ingredients: [
              'Sunflower seeds',
              'Pumpkin seeds',
              'Flax seeds',
              'Honey',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Caprese Panini',
            calories: 410,
            description:
                'A pressed panini with fresh mozzarella, tomato slices, basil, and balsamic glaze.',
            ingredients: [
              'Ciabatta bread',
              'Fresh mozzarella',
              'Tomato',
              'Fresh basil',
              'Balsamic glaze',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Thai Green Curry with Tofu',
            calories: 480,
            description:
                'Aromatic Thai green curry with crispy tofu, bamboo shoots, and jasmine rice.',
            ingredients: [
              'Tofu',
              'Green curry paste',
              'Coconut milk',
              'Bamboo shoots',
              'Jasmine rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 10
      // ============================================================
      DietDay(
        dayNumber: 10,
        standardMeals: [
          Meal(
            name: 'Bacon & Egg Muffin',
            calories: 400,
            description:
                'A toasted English muffin with crispy bacon, fried egg, and a slice of cheese.',
            ingredients: [
              'English muffin',
              'Bacon',
              'Egg',
              'American cheese',
              'Butter',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Cheese & Crackers',
            calories: 160,
            description:
                'Assorted cheese slices served with whole grain crackers for a savory snack.',
            ingredients: [
              'Cheddar cheese',
              'Gouda',
              'Whole grain crackers',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Tuna Poke Bowl',
            calories: 440,
            description:
                'Fresh diced tuna marinated in soy sauce over sushi rice with edamame and avocado.',
            ingredients: [
              'Ahi tuna',
              'Sushi rice',
              'Soy sauce',
              'Avocado',
              'Edamame',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Chicken Tikka Masala',
            calories: 530,
            description:
                'Tender chicken pieces in a rich and creamy tikka masala sauce with basmati rice.',
            ingredients: [
              'Chicken breast',
              'Tikka masala sauce',
              'Basmati rice',
              'Cream',
              'Cilantro',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Coconut Porridge',
            calories: 320,
            description:
                'Warm creamy porridge made with coconut milk, topped with toasted coconut flakes.',
            ingredients: [
              'Oats',
              'Coconut milk',
              'Coconut flakes',
              'Maple syrup',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Dried Fruit & Nuts',
            calories: 190,
            description:
                'A satisfying mix of dried apricots, figs, and cashews for an energy boost.',
            ingredients: [
              'Dried apricots',
              'Dried figs',
              'Cashews',
              'Almonds',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Lentil Soup & Bread',
            calories: 420,
            description:
                'A hearty bowl of spiced lentil soup served with a slice of crusty sourdough.',
            ingredients: [
              'Green lentils',
              'Carrots',
              'Celery',
              'Cumin',
              'Sourdough bread',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Vegetable Biryani',
            calories: 470,
            description:
                'Fragrant basmati rice layered with spiced mixed vegetables and saffron.',
            ingredients: [
              'Basmati rice',
              'Mixed vegetables',
              'Saffron',
              'Biryani spices',
              'Fried onions',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 11
      // ============================================================
      DietDay(
        dayNumber: 11,
        standardMeals: [
          Meal(
            name: 'Ham & Cheese Croissant',
            calories: 410,
            description:
                'A warm buttery croissant filled with sliced ham and melted Gruyere cheese.',
            ingredients: [
              'Croissant',
              'Ham',
              'Gruyere cheese',
              'Dijon mustard',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Turkey Roll-Ups',
            calories: 150,
            description:
                'Thin slices of turkey breast rolled around cucumber and cream cheese.',
            ingredients: [
              'Turkey breast',
              'Cucumber',
              'Cream cheese',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Mediterranean Chicken',
            calories: 450,
            description:
                'Grilled chicken thighs served with a Mediterranean salad of olives, feta, and quinoa.',
            ingredients: [
              'Chicken thighs',
              'Quinoa',
              'Kalamata olives',
              'Feta cheese',
              'Sun-dried tomatoes',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Herb Crusted Salmon',
            calories: 510,
            description:
                'Salmon fillet baked with a crispy herb and panko crust, served with green beans.',
            ingredients: [
              'Salmon fillet',
              'Panko breadcrumbs',
              'Fresh herbs',
              'Green beans',
              'Lemon',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Mango Lassi & Toast',
            calories: 330,
            description:
                'A chilled mango lassi yogurt drink paired with buttered whole wheat toast.',
            ingredients: [
              'Mango',
              'Yogurt',
              'Cardamom',
              'Whole wheat toast',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Hummus & Pita Chips',
            calories: 180,
            description:
                'Classic hummus served with crispy baked pita chips for a crunchy snack.',
            ingredients: [
              'Hummus',
              'Pita chips',
              'Olive oil',
              'Paprika',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Veggie Quesadilla',
            calories: 430,
            description:
                'A crispy tortilla filled with sauteed peppers, onions, beans, and melted cheese.',
            ingredients: [
              'Flour tortilla',
              'Bell peppers',
              'Onions',
              'Refried beans',
              'Cheddar cheese',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Mushroom Stroganoff',
            calories: 460,
            description:
                'Creamy mushroom stroganoff with a sour cream sauce served over egg noodles.',
            ingredients: [
              'Mixed mushrooms',
              'Sour cream',
              'Egg noodles',
              'Onion',
              'Parsley',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 12
      // ============================================================
      DietDay(
        dayNumber: 12,
        standardMeals: [
          Meal(
            name: 'Shakshuka',
            calories: 380,
            description:
                'Eggs poached in a spiced tomato and pepper sauce, served with crusty bread.',
            ingredients: [
              'Eggs',
              'Tomatoes',
              'Bell peppers',
              'Cumin',
              'Crusty bread',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Cottage Cheese & Walnuts',
            calories: 170,
            description:
                'Creamy cottage cheese topped with crunchy walnuts and a drizzle of honey.',
            ingredients: [
              'Cottage cheese',
              'Walnuts',
              'Honey',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Philly Cheesesteak',
            calories: 470,
            description:
                'Thinly sliced beef with sauteed onions and melted provolone on a hoagie roll.',
            ingredients: [
              'Beef sirloin',
              'Provolone cheese',
              'Onions',
              'Green peppers',
              'Hoagie roll',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Lemon Herb Chicken',
            calories: 500,
            description:
                'Juicy roasted chicken with a bright lemon-herb marinade and roasted potatoes.',
            ingredients: [
              'Chicken breast',
              'Lemon',
              'Fresh rosemary',
              'Garlic',
              'Baby potatoes',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Peanut Butter Banana Smoothie',
            calories: 350,
            description:
                'A thick smoothie blended with peanut butter, banana, oat milk, and a touch of cocoa.',
            ingredients: [
              'Peanut butter',
              'Banana',
              'Oat milk',
              'Cocoa powder',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Veggies & Guacamole',
            calories: 160,
            description:
                'Fresh cut vegetables served with a bowl of chunky homemade guacamole.',
            ingredients: [
              'Avocado',
              'Bell peppers',
              'Cucumber',
              'Lime juice',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Falafel Bowl',
            calories: 420,
            description:
                'Crispy falafel over a bed of greens with hummus, pickled vegetables, and tahini.',
            ingredients: [
              'Falafel',
              'Mixed greens',
              'Hummus',
              'Pickled vegetables',
              'Tahini',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Eggplant Moussaka',
            calories: 480,
            description:
                'Layers of roasted eggplant, spiced lentils, and creamy bechamel sauce baked golden.',
            ingredients: [
              'Eggplant',
              'Lentils',
              'Bechamel sauce',
              'Tomato sauce',
              'Parmesan',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 13
      // ============================================================
      DietDay(
        dayNumber: 13,
        standardMeals: [
          Meal(
            name: 'Huevos Rancheros',
            calories: 400,
            description:
                'Fried eggs on corn tortillas with black bean puree, salsa roja, and fresh cilantro.',
            ingredients: [
              'Eggs',
              'Corn tortillas',
              'Black beans',
              'Salsa roja',
              'Cilantro',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Protein Bar',
            calories: 190,
            description:
                'A peanut butter flavored protein bar with a chocolate coating for a quick boost.',
            ingredients: [
              'Whey protein',
              'Peanut butter',
              'Chocolate coating',
              'Oats',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Asian Chicken Salad',
            calories: 430,
            description:
                'Shredded chicken tossed with cabbage, edamame, and a sesame-ginger dressing.',
            ingredients: [
              'Chicken breast',
              'Napa cabbage',
              'Edamame',
              'Mandarin oranges',
              'Sesame-ginger dressing',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Garlic Butter Shrimp',
            calories: 510,
            description:
                'Succulent shrimp sauteed in garlic butter served over angel hair pasta.',
            ingredients: [
              'Shrimp',
              'Garlic',
              'Butter',
              'Angel hair pasta',
              'Parsley',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'French Toast Sticks',
            calories: 340,
            description:
                'Golden crispy French toast sticks served with warm maple syrup for dipping.',
            ingredients: [
              'Bread',
              'Eggs',
              'Cinnamon',
              'Vanilla',
              'Maple syrup',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Yogurt & Granola',
            calories: 170,
            description:
                'A small bowl of vanilla yogurt topped with a handful of crunchy granola.',
            ingredients: [
              'Vanilla yogurt',
              'Granola',
              'Honey',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Black Bean Tacos',
            calories: 420,
            description:
                'Seasoned black bean tacos topped with avocado crema, salsa verde, and cilantro.',
            ingredients: [
              'Black beans',
              'Corn tortillas',
              'Avocado crema',
              'Salsa verde',
              'Cilantro',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Cauliflower Tikka',
            calories: 460,
            description:
                'Roasted cauliflower florets coated in tikka spices served with basmati rice and raita.',
            ingredients: [
              'Cauliflower',
              'Tikka spices',
              'Basmati rice',
              'Yogurt raita',
              'Cilantro',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 14
      // ============================================================
      DietDay(
        dayNumber: 14,
        standardMeals: [
          Meal(
            name: 'Eggs Florentine',
            calories: 380,
            description:
                'Poached eggs over sauteed spinach on an English muffin with hollandaise.',
            ingredients: [
              'Eggs',
              'Spinach',
              'English muffin',
              'Hollandaise sauce',
              'Nutmeg',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Mixed Berry Smoothie',
            calories: 160,
            description:
                'A refreshing smoothie blended with mixed berries, banana, and a splash of orange juice.',
            ingredients: [
              'Mixed berries',
              'Banana',
              'Orange juice',
              'Ice',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Chicken Gyro',
            calories: 450,
            description:
                'Seasoned chicken gyro meat wrapped in warm pita with tzatziki and fresh veggies.',
            ingredients: [
              'Chicken gyro meat',
              'Pita bread',
              'Tzatziki sauce',
              'Tomato',
              'Red onion',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Pan-Seared Tilapia',
            calories: 490,
            description:
                'Lightly breaded tilapia pan-seared to golden perfection with a lemon-caper sauce.',
            ingredients: [
              'Tilapia fillet',
              'Capers',
              'Lemon',
              'Butter',
              'Steamed rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Buckwheat Pancakes',
            calories: 330,
            description:
                'Nutty buckwheat pancakes topped with fresh berries and a dollop of yogurt.',
            ingredients: [
              'Buckwheat flour',
              'Eggs',
              'Milk',
              'Berries',
              'Yogurt',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Apple Slices & Almonds',
            calories: 150,
            description:
                'Crisp apple slices served alongside a small portion of raw almonds.',
            ingredients: [
              'Apple',
              'Raw almonds',
              'Cinnamon',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Moroccan Couscous',
            calories: 430,
            description:
                'Fluffy couscous tossed with roasted vegetables, chickpeas, and a harissa dressing.',
            ingredients: [
              'Couscous',
              'Chickpeas',
              'Roasted vegetables',
              'Harissa',
              'Fresh mint',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Spinach Lasagna',
            calories: 480,
            description:
                'Layers of lasagna noodles, ricotta-spinach filling, and marinara baked until bubbly.',
            ingredients: [
              'Lasagna noodles',
              'Ricotta cheese',
              'Spinach',
              'Marinara sauce',
              'Mozzarella',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 15
      // ============================================================
      DietDay(
        dayNumber: 15,
        standardMeals: [
          Meal(
            name: 'Chorizo & Egg Wrap',
            calories: 420,
            description:
                'Spiced chorizo and scrambled eggs wrapped in a warm flour tortilla with salsa.',
            ingredients: [
              'Chorizo',
              'Eggs',
              'Flour tortilla',
              'Salsa',
              'Cheddar cheese',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Beef Sticks',
            calories: 170,
            description:
                'Savory dried beef sticks made with lean beef and a blend of spices.',
            ingredients: [
              'Lean beef',
              'Garlic powder',
              'Black pepper',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Fish & Chips (baked)',
            calories: 460,
            description:
                'Oven-baked crispy fish fillets served with baked potato wedges and tartar sauce.',
            ingredients: [
              'Cod fillet',
              'Panko breadcrumbs',
              'Potatoes',
              'Tartar sauce',
              'Lemon',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Chicken Marsala',
            calories: 520,
            description:
                'Pan-seared chicken cutlets in a rich Marsala wine and mushroom sauce with pasta.',
            ingredients: [
              'Chicken breast',
              'Marsala wine',
              'Mushrooms',
              'Butter',
              'Pasta',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Tropical Smoothie Bowl',
            calories: 350,
            description:
                'A vibrant smoothie bowl with mango, pineapple, and coconut topped with granola.',
            ingredients: [
              'Mango',
              'Pineapple',
              'Coconut milk',
              'Granola',
              'Chia seeds',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Edamame & Sea Salt',
            calories: 140,
            description:
                'Lightly steamed edamame pods tossed with coarse sea salt.',
            ingredients: [
              'Edamame',
              'Sea salt',
              'Chili flakes',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Veggie Pho',
            calories: 410,
            description:
                'A fragrant vegetable pho with rice noodles, mushrooms, and fresh herbs in a spiced broth.',
            ingredients: [
              'Rice noodles',
              'Mushrooms',
              'Star anise broth',
              'Bean sprouts',
              'Thai basil',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Chana Masala',
            calories: 470,
            description:
                'Spiced chickpea curry in a tangy tomato sauce served with warm basmati rice.',
            ingredients: [
              'Chickpeas',
              'Tomatoes',
              'Garam masala',
              'Onion',
              'Basmati rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 16
      // ============================================================
      DietDay(
        dayNumber: 16,
        standardMeals: [
          Meal(
            name: 'Corned Beef Hash & Eggs',
            calories: 430,
            description:
                'Crispy corned beef hash topped with two sunny-side-up eggs and fresh chives.',
            ingredients: [
              'Corned beef',
              'Potatoes',
              'Eggs',
              'Onion',
              'Chives',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'String Cheese & Fruit',
            calories: 150,
            description:
                'A stick of mozzarella string cheese paired with a handful of fresh grapes.',
            ingredients: [
              'Mozzarella string cheese',
              'Grapes',
              'Apple slices',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Cobb Salad',
            calories: 440,
            description:
                'Classic Cobb salad with rows of chicken, egg, bacon, avocado, and blue cheese.',
            ingredients: [
              'Chicken breast',
              'Hard boiled egg',
              'Bacon',
              'Avocado',
              'Blue cheese',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Honey Garlic Salmon',
            calories: 510,
            description:
                'Salmon fillets glazed with a sticky honey garlic sauce and served with rice.',
            ingredients: [
              'Salmon fillet',
              'Honey',
              'Garlic',
              'Soy sauce',
              'Steamed rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Matcha Overnight Oats',
            calories: 320,
            description:
                'Overnight oats infused with matcha green tea powder and topped with sliced kiwi.',
            ingredients: [
              'Rolled oats',
              'Matcha powder',
              'Almond milk',
              'Kiwi',
              'Honey',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Roasted Almonds',
            calories: 180,
            description:
                'A portion of dry-roasted almonds with a light dusting of sea salt.',
            ingredients: [
              'Almonds',
              'Sea salt',
              'Olive oil',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Mediterranean Pasta Salad',
            calories: 430,
            description:
                'Rotini pasta tossed with olives, sun-dried tomatoes, feta, and Italian dressing.',
            ingredients: [
              'Rotini pasta',
              'Kalamata olives',
              'Sun-dried tomatoes',
              'Feta cheese',
              'Italian dressing',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Tofu Tikka Masala',
            calories: 470,
            description:
                'Crispy tofu cubes simmered in a creamy tikka masala sauce with fragrant rice.',
            ingredients: [
              'Tofu',
              'Tikka masala sauce',
              'Cream',
              'Basmati rice',
              'Cilantro',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 17
      // ============================================================
      DietDay(
        dayNumber: 17,
        standardMeals: [
          Meal(
            name: 'Smoked Turkey & Egg Sandwich',
            calories: 390,
            description:
                'Smoked turkey and a fried egg stacked on a toasted ciabatta with arugula.',
            ingredients: [
              'Smoked turkey',
              'Egg',
              'Ciabatta bread',
              'Arugula',
              'Aioli',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Yogurt & Honey',
            calories: 170,
            description:
                'Thick Greek yogurt drizzled with raw honey and a sprinkle of bee pollen.',
            ingredients: [
              'Greek yogurt',
              'Raw honey',
              'Bee pollen',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Chicken Burrito Bowl',
            calories: 460,
            description:
                'Seasoned chicken over cilantro-lime rice with black beans, corn, and pico de gallo.',
            ingredients: [
              'Chicken breast',
              'Cilantro-lime rice',
              'Black beans',
              'Corn',
              'Pico de gallo',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Beef Stir Fry with Noodles',
            calories: 530,
            description:
                'Sliced beef stir-fried with vegetables and lo mein noodles in a savory sauce.',
            ingredients: [
              'Beef sirloin',
              'Lo mein noodles',
              'Bell peppers',
              'Soy sauce',
              'Sesame oil',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Banana Oat Smoothie',
            calories: 340,
            description:
                'A filling smoothie blended with banana, oats, almond butter, and oat milk.',
            ingredients: [
              'Banana',
              'Rolled oats',
              'Almond butter',
              'Oat milk',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Pumpkin Seeds',
            calories: 160,
            description:
                'Toasted pumpkin seeds seasoned with smoked paprika and a touch of cayenne.',
            ingredients: [
              'Pumpkin seeds',
              'Smoked paprika',
              'Cayenne',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Thai Peanut Noodles',
            calories: 440,
            description:
                'Rice noodles tossed in a creamy peanut sauce with shredded vegetables and lime.',
            ingredients: [
              'Rice noodles',
              'Peanut butter',
              'Soy sauce',
              'Lime',
              'Shredded carrots',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Dal Makhani',
            calories: 470,
            description:
                'Slow-cooked black lentils in a buttery tomato cream sauce with warm naan bread.',
            ingredients: [
              'Black lentils',
              'Tomatoes',
              'Butter',
              'Cream',
              'Naan bread',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 18
      // ============================================================
      DietDay(
        dayNumber: 18,
        standardMeals: [
          Meal(
            name: 'Veggie & Cheese Omelette',
            calories: 370,
            description:
                'A fluffy omelette packed with diced tomatoes, spinach, and melted cheddar cheese.',
            ingredients: [
              'Eggs',
              'Tomatoes',
              'Spinach',
              'Cheddar cheese',
              'Butter',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Trail Mix Bar',
            calories: 180,
            description:
                'A chewy trail mix bar loaded with oats, dried fruit, and dark chocolate chips.',
            ingredients: [
              'Oats',
              'Dried cranberries',
              'Dark chocolate chips',
              'Honey',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Lamb Shawarma',
            calories: 470,
            description:
                'Tender spiced lamb shawarma wrapped in flatbread with pickled turnips and garlic sauce.',
            ingredients: [
              'Lamb',
              'Flatbread',
              'Pickled turnips',
              'Garlic sauce',
              'Sumac',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Grilled Sea Bass',
            calories: 500,
            description:
                'Perfectly grilled sea bass with a Mediterranean salsa of tomatoes, capers, and olives.',
            ingredients: [
              'Sea bass',
              'Cherry tomatoes',
              'Capers',
              'Olives',
              'Olive oil',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Blueberry Muffin & Latte',
            calories: 350,
            description:
                'A warm blueberry oat muffin paired with a creamy oat milk latte.',
            ingredients: [
              'Blueberries',
              'Oat flour',
              'Oat milk',
              'Espresso',
              'Honey',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Carrots & Ranch',
            calories: 140,
            description:
                'Crunchy baby carrots served with a light and tangy ranch dip.',
            ingredients: [
              'Baby carrots',
              'Greek yogurt ranch',
              'Dill',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Stuffed Avocado',
            calories: 410,
            description:
                'Ripe avocado halves stuffed with a quinoa, corn, and black bean mixture.',
            ingredients: [
              'Avocado',
              'Quinoa',
              'Corn',
              'Black beans',
              'Lime juice',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Vegetable Korma',
            calories: 480,
            description:
                'Mixed vegetables simmered in a mild and creamy cashew-based korma sauce with rice.',
            ingredients: [
              'Mixed vegetables',
              'Cashew cream',
              'Coconut milk',
              'Korma spices',
              'Basmati rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 19
      // ============================================================
      DietDay(
        dayNumber: 19,
        standardMeals: [
          Meal(
            name: 'Belgian Waffle & Eggs',
            calories: 410,
            description:
                'A crispy Belgian waffle served alongside two scrambled eggs and fresh fruit.',
            ingredients: [
              'Belgian waffle',
              'Eggs',
              'Butter',
              'Strawberries',
              'Maple syrup',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Almonds & Dried Mango',
            calories: 170,
            description:
                'A sweet and savory mix of roasted almonds and chewy dried mango slices.',
            ingredients: [
              'Almonds',
              'Dried mango',
              'Sea salt',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Korean Bibimbap',
            calories: 450,
            description:
                'A colorful rice bowl topped with seasoned beef, vegetables, egg, and gochujang sauce.',
            ingredients: [
              'Steamed rice',
              'Beef bulgogi',
              'Spinach',
              'Carrots',
              'Gochujang',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Herb Roasted Chicken Thighs',
            calories: 520,
            description:
                'Juicy chicken thighs roasted with fresh herbs and served with roasted root vegetables.',
            ingredients: [
              'Chicken thighs',
              'Fresh thyme',
              'Rosemary',
              'Root vegetables',
              'Olive oil',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Sweet Potato Hash',
            calories: 330,
            description:
                'Diced sweet potatoes pan-fried with peppers and onions, topped with a fried egg.',
            ingredients: [
              'Sweet potato',
              'Bell peppers',
              'Onion',
              'Egg',
              'Paprika',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Energy Balls',
            calories: 180,
            description:
                'No-bake energy balls rolled from oats, dates, peanut butter, and chocolate chips.',
            ingredients: [
              'Oats',
              'Dates',
              'Peanut butter',
              'Chocolate chips',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Buddha Noodle Bowl',
            calories: 430,
            description:
                'Soba noodles tossed with edamame, avocado, and a miso-sesame dressing.',
            ingredients: [
              'Soba noodles',
              'Edamame',
              'Avocado',
              'Miso paste',
              'Sesame oil',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Paneer Butter Masala',
            calories: 470,
            description:
                'Soft paneer cubes in a velvety butter tomato sauce served with garlic naan.',
            ingredients: [
              'Paneer',
              'Tomato sauce',
              'Butter',
              'Cream',
              'Garlic naan',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 20
      // ============================================================
      DietDay(
        dayNumber: 20,
        standardMeals: [
          Meal(
            name: 'Lox & Cream Cheese Bagel',
            calories: 400,
            description:
                'A toasted sesame bagel spread with cream cheese and layered with lox and red onion.',
            ingredients: [
              'Sesame bagel',
              'Cream cheese',
              'Lox',
              'Red onion',
              'Capers',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Beef Jerky',
            calories: 160,
            description:
                'A portion of peppered beef jerky for a high-protein, low-fat snack.',
            ingredients: [
              'Beef jerky',
              'Black pepper',
              'Soy sauce',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Chicken Souvlaki Wrap',
            calories: 440,
            description:
                'Marinated chicken souvlaki in warm pita with tzatziki, tomatoes, and onions.',
            ingredients: [
              'Chicken souvlaki',
              'Pita bread',
              'Tzatziki',
              'Tomatoes',
              'Red onion',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Miso Glazed Salmon',
            calories: 520,
            description:
                'Rich miso-glazed salmon broiled until caramelized, served with steamed bok choy.',
            ingredients: [
              'Salmon fillet',
              'White miso',
              'Mirin',
              'Bok choy',
              'Steamed rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Quinoa Porridge',
            calories: 320,
            description:
                'Warm quinoa porridge cooked in almond milk with cinnamon and topped with berries.',
            ingredients: [
              'Quinoa',
              'Almond milk',
              'Cinnamon',
              'Berries',
              'Maple syrup',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Kale Chips',
            calories: 130,
            description:
                'Crispy baked kale chips seasoned with nutritional yeast and garlic powder.',
            ingredients: [
              'Kale',
              'Nutritional yeast',
              'Garlic powder',
              'Olive oil',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Falafel Wrap',
            calories: 440,
            description:
                'Warm falafel wrapped in lavash bread with hummus, pickled turnips, and fresh vegetables.',
            ingredients: [
              'Falafel',
              'Lavash bread',
              'Hummus',
              'Pickled turnips',
              'Lettuce',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Sweet Potato Black Bean Chili',
            calories: 490,
            description:
                'A hearty chili loaded with sweet potatoes, black beans, and smoky chipotle spices.',
            ingredients: [
              'Sweet potatoes',
              'Black beans',
              'Tomatoes',
              'Chipotle peppers',
              'Corn',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 21
      // ============================================================
      DietDay(
        dayNumber: 21,
        standardMeals: [
          Meal(
            name: 'Breakfast Quesadilla',
            calories: 390,
            description:
                'A crispy tortilla filled with scrambled eggs, cheese, peppers, and salsa.',
            ingredients: [
              'Flour tortilla',
              'Eggs',
              'Cheese',
              'Bell peppers',
              'Salsa',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Hummus & Veggies',
            calories: 160,
            description:
                'Classic hummus served with a colorful assortment of sliced raw vegetables.',
            ingredients: [
              'Hummus',
              'Bell peppers',
              'Celery',
              'Carrots',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Sushi Roll Platter',
            calories: 450,
            description:
                'An assorted platter of fresh salmon and tuna sushi rolls with pickled ginger.',
            ingredients: [
              'Sushi rice',
              'Salmon',
              'Tuna',
              'Nori',
              'Pickled ginger',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Chicken Cacciatore',
            calories: 530,
            description:
                'Rustic braised chicken in a tomato, olive, and herb sauce served over polenta.',
            ingredients: [
              'Chicken thighs',
              'Tomatoes',
              'Olives',
              'Capers',
              'Polenta',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Apple Cinnamon Oatmeal',
            calories: 330,
            description:
                'Warm oatmeal swirled with diced apples, cinnamon, and a drizzle of maple syrup.',
            ingredients: [
              'Rolled oats',
              'Apple',
              'Cinnamon',
              'Maple syrup',
              'Milk',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Trail Mix',
            calories: 180,
            description:
                'A hearty trail mix with almonds, cashews, raisins, and coconut flakes.',
            ingredients: [
              'Almonds',
              'Cashews',
              'Raisins',
              'Coconut flakes',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Veggie Spring Rolls & Rice',
            calories: 420,
            description:
                'Fresh vegetable spring rolls with a sweet chili dipping sauce and jasmine rice.',
            ingredients: [
              'Rice paper',
              'Vermicelli noodles',
              'Vegetables',
              'Sweet chili sauce',
              'Jasmine rice',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Aloo Gobi with Roti',
            calories: 470,
            description:
                'A classic Indian dish of spiced potatoes and cauliflower served with warm roti.',
            ingredients: [
              'Potatoes',
              'Cauliflower',
              'Turmeric',
              'Cumin',
              'Roti',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 22
      // ============================================================
      DietDay(
        dayNumber: 22,
        standardMeals: [
          Meal(
            name: 'Steak & Eggs',
            calories: 430,
            description:
                'A classic breakfast of pan-seared steak strips with two sunny-side-up eggs and toast.',
            ingredients: [
              'Sirloin steak',
              'Eggs',
              'Toast',
              'Butter',
              'Salt & pepper',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Protein Shake',
            calories: 170,
            description:
                'A creamy chocolate protein shake blended with ice and a splash of almond milk.',
            ingredients: [
              'Chocolate protein powder',
              'Almond milk',
              'Ice',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Grilled Chicken Panini',
            calories: 440,
            description:
                'Pressed panini with grilled chicken, roasted red peppers, and pesto on sourdough.',
            ingredients: [
              'Chicken breast',
              'Sourdough bread',
              'Roasted red peppers',
              'Pesto',
              'Mozzarella',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Baked Halibut',
            calories: 490,
            description:
                'Flaky halibut baked with a citrus glaze and served with wild rice pilaf.',
            ingredients: [
              'Halibut fillet',
              'Orange glaze',
              'Wild rice',
              'Asparagus',
              'Dill',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Acerola Berry Bowl',
            calories: 340,
            description:
                'A vibrant acerola berry smoothie base topped with sliced fruits and hemp seeds.',
            ingredients: [
              'Acerola berries',
              'Banana',
              'Hemp seeds',
              'Granola',
              'Coconut flakes',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Roasted Chickpeas',
            calories: 150,
            description:
                'Crunchy roasted chickpeas seasoned with turmeric and black pepper.',
            ingredients: [
              'Chickpeas',
              'Turmeric',
              'Black pepper',
              'Olive oil',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Greek Mezze Platter',
            calories: 430,
            description:
                'A Mediterranean platter of hummus, baba ganoush, olives, feta, and warm pita.',
            ingredients: [
              'Hummus',
              'Baba ganoush',
              'Kalamata olives',
              'Feta cheese',
              'Pita bread',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Mushroom & Truffle Risotto',
            calories: 480,
            description:
                'A luxurious risotto with wild mushrooms finished with truffle oil and parmesan.',
            ingredients: [
              'Arborio rice',
              'Wild mushrooms',
              'Truffle oil',
              'Parmesan',
              'Vegetable broth',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 23
      // ============================================================
      DietDay(
        dayNumber: 23,
        standardMeals: [
          Meal(
            name: 'Croque Monsieur',
            calories: 400,
            description:
                'A classic French grilled ham and cheese sandwich topped with creamy bechamel.',
            ingredients: [
              'Bread',
              'Ham',
              'Gruyere cheese',
              'Bechamel sauce',
              'Butter',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Cucumber & Turkey Rolls',
            calories: 150,
            description:
                'Thin turkey slices wrapped around cucumber spears with a smear of cream cheese.',
            ingredients: [
              'Turkey breast',
              'Cucumber',
              'Cream cheese',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Vietnamese Pho',
            calories: 460,
            description:
                'A steaming bowl of traditional beef pho with rice noodles, herbs, and lime.',
            ingredients: [
              'Beef broth',
              'Rice noodles',
              'Beef slices',
              'Bean sprouts',
              'Lime',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Lamb Chops & Couscous',
            calories: 530,
            description:
                'Perfectly seared lamb chops served with herbed couscous and a mint yogurt sauce.',
            ingredients: [
              'Lamb chops',
              'Couscous',
              'Mint',
              'Yogurt',
              'Olive oil',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Chai Spiced Oatmeal',
            calories: 320,
            description:
                'Warm oatmeal infused with chai spices and topped with sliced pear and walnuts.',
            ingredients: [
              'Rolled oats',
              'Chai spices',
              'Pear',
              'Walnuts',
              'Milk',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Dates & Walnuts',
            calories: 180,
            description:
                'Sweet Medjool dates stuffed with walnut halves for a naturally energizing snack.',
            ingredients: [
              'Medjool dates',
              'Walnuts',
              'Sea salt',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Tempeh Teriyaki Bowl',
            calories: 430,
            description:
                'Glazed teriyaki tempeh over brown rice with steamed broccoli and pickled radish.',
            ingredients: [
              'Tempeh',
              'Teriyaki sauce',
              'Brown rice',
              'Broccoli',
              'Pickled radish',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Saag Paneer',
            calories: 470,
            description:
                'Rich and creamy spinach gravy loaded with soft paneer cubes, served with naan.',
            ingredients: [
              'Paneer',
              'Spinach',
              'Cream',
              'Garlic',
              'Naan bread',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 24
      // ============================================================
      DietDay(
        dayNumber: 24,
        standardMeals: [
          Meal(
            name: 'Breakfast Hash Browns & Eggs',
            calories: 410,
            description:
                'Crispy golden hash browns served with two fried eggs and a side of ketchup.',
            ingredients: [
              'Potatoes',
              'Eggs',
              'Butter',
              'Onion',
              'Ketchup',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Smoked Salmon Bites',
            calories: 160,
            description:
                'Delicate smoked salmon on cucumber rounds topped with dill cream cheese.',
            ingredients: [
              'Smoked salmon',
              'Cucumber',
              'Cream cheese',
              'Dill',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Chicken Fajitas',
            calories: 450,
            description:
                'Sizzling chicken fajitas with grilled peppers and onions in warm tortillas.',
            ingredients: [
              'Chicken breast',
              'Bell peppers',
              'Onions',
              'Flour tortillas',
              'Sour cream',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Seared Ahi Tuna',
            calories: 510,
            description:
                'Sesame-crusted seared ahi tuna served rare with wasabi, soy sauce, and Asian slaw.',
            ingredients: [
              'Ahi tuna',
              'Sesame seeds',
              'Soy sauce',
              'Wasabi',
              'Asian slaw',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Muesli & Fresh Berries',
            calories: 330,
            description:
                'A bowl of bircher muesli soaked overnight and topped with fresh seasonal berries.',
            ingredients: [
              'Muesli',
              'Yogurt',
              'Berries',
              'Honey',
              'Apple',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Pistachios',
            calories: 170,
            description:
                'A handful of lightly salted shelled pistachios for a satisfying crunch.',
            ingredients: [
              'Pistachios',
              'Sea salt',
              'Lemon zest',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Veggie Enchiladas',
            calories: 440,
            description:
                'Corn tortillas filled with black beans, corn, and cheese, smothered in enchilada sauce.',
            ingredients: [
              'Corn tortillas',
              'Black beans',
              'Corn',
              'Cheese',
              'Enchilada sauce',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Tofu Pad See Ew',
            calories: 460,
            description:
                'Wide rice noodles stir-fried with tofu, Chinese broccoli, and sweet soy sauce.',
            ingredients: [
              'Wide rice noodles',
              'Tofu',
              'Chinese broccoli',
              'Sweet soy sauce',
              'Garlic',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 25
      // ============================================================
      DietDay(
        dayNumber: 25,
        standardMeals: [
          Meal(
            name: 'Eggs en Cocotte',
            calories: 380,
            description:
                'Eggs baked in ramekins with cream, chives, and a touch of Gruyere cheese.',
            ingredients: [
              'Eggs',
              'Heavy cream',
              'Gruyere cheese',
              'Chives',
              'Toast soldiers',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Cheese & Apple Slices',
            calories: 170,
            description:
                'Sharp cheddar cheese slices paired with crisp Granny Smith apple wedges.',
            ingredients: [
              'Cheddar cheese',
              'Granny Smith apple',
              'Walnuts',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Turkey Club Sandwich',
            calories: 450,
            description:
                'A triple-decker turkey club with bacon, lettuce, tomato, and mayo on toasted bread.',
            ingredients: [
              'Turkey breast',
              'Bacon',
              'Lettuce',
              'Tomato',
              'Toasted bread',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Butter Chicken & Rice',
            calories: 540,
            description:
                'Succulent chicken pieces in a rich buttery tomato cream sauce with basmati rice.',
            ingredients: [
              'Chicken breast',
              'Tomato sauce',
              'Butter',
              'Cream',
              'Basmati rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Pumpkin Spice Pancakes',
            calories: 350,
            description:
                'Fluffy pancakes made with pumpkin puree and warm autumn spices.',
            ingredients: [
              'Pumpkin puree',
              'Flour',
              'Eggs',
              'Cinnamon',
              'Maple syrup',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Chia Pudding Cup',
            calories: 150,
            description:
                'A small cup of vanilla chia pudding with a swirl of berry compote.',
            ingredients: [
              'Chia seeds',
              'Almond milk',
              'Vanilla',
              'Berry compote',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Loaded Veggie Nachos',
            calories: 440,
            description:
                'Crispy tortilla chips loaded with beans, cheese, jalapenos, salsa, and guacamole.',
            ingredients: [
              'Tortilla chips',
              'Refried beans',
              'Cheese',
              'Jalapenos',
              'Guacamole',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Vegetable Tagine',
            calories: 460,
            description:
                'A Moroccan-spiced vegetable tagine with chickpeas, apricots, and couscous.',
            ingredients: [
              'Chickpeas',
              'Dried apricots',
              'Zucchini',
              'Moroccan spices',
              'Couscous',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 26
      // ============================================================
      DietDay(
        dayNumber: 26,
        standardMeals: [
          Meal(
            name: 'Brioche French Toast',
            calories: 400,
            description:
                'Thick-cut brioche dipped in custard and griddled until golden, with powdered sugar.',
            ingredients: [
              'Brioche bread',
              'Eggs',
              'Milk',
              'Vanilla',
              'Powdered sugar',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Mixed Nuts & Raisins',
            calories: 170,
            description:
                'A wholesome mix of almonds, cashews, and plump golden raisins.',
            ingredients: [
              'Almonds',
              'Cashews',
              'Golden raisins',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Chicken Katsu Curry',
            calories: 460,
            description:
                'Crispy breaded chicken katsu served with a mild Japanese curry sauce and steamed rice.',
            ingredients: [
              'Chicken breast',
              'Panko breadcrumbs',
              'Japanese curry sauce',
              'Steamed rice',
              'Pickled ginger',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Garlic Rosemary Pork',
            calories: 520,
            description:
                'Tender roasted pork loin rubbed with garlic and rosemary, served with roasted potatoes.',
            ingredients: [
              'Pork loin',
              'Garlic',
              'Fresh rosemary',
              'Potatoes',
              'Olive oil',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Coconut Chia Smoothie',
            calories: 330,
            description:
                'A tropical smoothie with coconut milk, chia seeds, pineapple, and spinach.',
            ingredients: [
              'Coconut milk',
              'Chia seeds',
              'Pineapple',
              'Spinach',
              'Honey',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Popcorn & Nutritional Yeast',
            calories: 140,
            description:
                'Air-popped popcorn sprinkled with nutritional yeast for a cheesy vegan snack.',
            ingredients: [
              'Popcorn kernels',
              'Nutritional yeast',
              'Olive oil',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Grilled Halloumi Salad',
            calories: 440,
            description:
                'Grilled halloumi cheese over a bed of mixed greens, pomegranate, and walnuts.',
            ingredients: [
              'Halloumi cheese',
              'Mixed greens',
              'Pomegranate seeds',
              'Walnuts',
              'Lemon dressing',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Rajma Chawal',
            calories: 490,
            description:
                'Kidney beans simmered in a spiced tomato gravy served over steamed basmati rice.',
            ingredients: [
              'Kidney beans',
              'Tomatoes',
              'Onion',
              'Rajma spices',
              'Basmati rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 27
      // ============================================================
      DietDay(
        dayNumber: 27,
        standardMeals: [
          Meal(
            name: 'Egg in a Hole Toast',
            calories: 370,
            description:
                'A fried egg cooked inside a hole cut in a slice of sourdough toast.',
            ingredients: [
              'Sourdough bread',
              'Egg',
              'Butter',
              'Salt & pepper',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Beef Jerky & Fruit',
            calories: 180,
            description:
                'Lean beef jerky paired with a small cup of fresh mixed fruit.',
            ingredients: [
              'Beef jerky',
              'Grapes',
              'Orange slices',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Fish Tacos',
            calories: 440,
            description:
                'Battered fish tacos with shredded cabbage, pico de gallo, and chipotle crema.',
            ingredients: [
              'White fish',
              'Corn tortillas',
              'Cabbage',
              'Pico de gallo',
              'Chipotle crema',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Chicken Alfredo',
            calories: 540,
            description:
                'Creamy chicken Alfredo with fettuccine pasta and a sprinkle of parmesan.',
            ingredients: [
              'Chicken breast',
              'Fettuccine',
              'Alfredo sauce',
              'Parmesan',
              'Garlic',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Berry Compote & Yogurt',
            calories: 320,
            description:
                'Warm berry compote spooned over thick Greek yogurt with a sprinkle of granola.',
            ingredients: [
              'Mixed berries',
              'Greek yogurt',
              'Granola',
              'Honey',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Hummus & Veggie Sticks',
            calories: 160,
            description:
                'Creamy garlic hummus with an assortment of fresh-cut vegetable sticks.',
            ingredients: [
              'Hummus',
              'Carrots',
              'Celery',
              'Bell peppers',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Pesto Pasta Salad',
            calories: 440,
            description:
                'Fusilli pasta tossed in fresh basil pesto with cherry tomatoes, pine nuts, and mozzarella.',
            ingredients: [
              'Fusilli pasta',
              'Basil pesto',
              'Cherry tomatoes',
              'Pine nuts',
              'Fresh mozzarella',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Chili Sin Carne',
            calories: 480,
            description:
                'A hearty meatless chili with kidney beans, black beans, corn, and smoky spices.',
            ingredients: [
              'Kidney beans',
              'Black beans',
              'Corn',
              'Tomatoes',
              'Smoked paprika',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 28
      // ============================================================
      DietDay(
        dayNumber: 28,
        standardMeals: [
          Meal(
            name: 'Full English Breakfast',
            calories: 440,
            description:
                'A traditional English breakfast with eggs, bacon, sausage, beans, and toast.',
            ingredients: [
              'Eggs',
              'Bacon',
              'Sausage',
              'Baked beans',
              'Toast',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Protein Bar',
            calories: 180,
            description:
                'A cookies and cream protein bar for a quick and filling mid-morning snack.',
            ingredients: [
              'Whey protein',
              'Cocoa',
              'Oats',
              'Cream filling',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Chicken Caesar Salad',
            calories: 430,
            description:
                'Crisp romaine lettuce with grilled chicken, croutons, and creamy Caesar dressing.',
            ingredients: [
              'Chicken breast',
              'Romaine lettuce',
              'Croutons',
              'Caesar dressing',
              'Parmesan',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Grilled Swordfish',
            calories: 500,
            description:
                'Thick grilled swordfish steak with a bright lemon-olive relish and couscous.',
            ingredients: [
              'Swordfish steak',
              'Lemon',
              'Olives',
              'Couscous',
              'Olive oil',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Granola Clusters & Milk',
            calories: 340,
            description:
                'Crunchy baked granola clusters served in a bowl with cold oat milk.',
            ingredients: [
              'Granola clusters',
              'Oat milk',
              'Dried cranberries',
              'Pumpkin seeds',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Fruit & Nut Butter',
            calories: 170,
            description:
                'Sliced pear and banana with a side of cashew nut butter for dipping.',
            ingredients: [
              'Pear',
              'Banana',
              'Cashew butter',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Veggie Bahn Mi',
            calories: 420,
            description:
                'A Vietnamese-inspired baguette with marinated tofu, pickled daikon, and sriracha mayo.',
            ingredients: [
              'Baguette',
              'Marinated tofu',
              'Pickled daikon',
              'Cilantro',
              'Sriracha mayo',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Vegetable Laksa',
            calories: 470,
            description:
                'A spicy coconut curry laksa loaded with vegetables, tofu puffs, and rice noodles.',
            ingredients: [
              'Rice noodles',
              'Coconut milk',
              'Laksa paste',
              'Tofu puffs',
              'Bean sprouts',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 29
      // ============================================================
      DietDay(
        dayNumber: 29,
        standardMeals: [
          Meal(
            name: 'Smoked Salmon Scramble',
            calories: 400,
            description:
                'Soft scrambled eggs folded with smoked salmon, cream cheese, and fresh dill.',
            ingredients: [
              'Eggs',
              'Smoked salmon',
              'Cream cheese',
              'Dill',
              'Chives',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Hard Boiled Eggs & Avocado',
            calories: 180,
            description:
                'Sliced hard boiled eggs served with avocado wedges and a pinch of everything seasoning.',
            ingredients: [
              'Hard boiled eggs',
              'Avocado',
              'Everything seasoning',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Beef Pho',
            calories: 460,
            description:
                'A rich and aromatic beef pho with tender sliced beef, noodles, and fresh herbs.',
            ingredients: [
              'Beef broth',
              'Beef slices',
              'Rice noodles',
              'Thai basil',
              'Hoisin sauce',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Lemon Pepper Chicken',
            calories: 510,
            description:
                'Zesty lemon pepper chicken breast baked until golden and served with roasted vegetables.',
            ingredients: [
              'Chicken breast',
              'Lemon',
              'Black pepper',
              'Garlic',
              'Roasted vegetables',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Raspberry Smoothie Bowl',
            calories: 330,
            description:
                'A thick raspberry smoothie bowl topped with sliced banana, coconut, and flax seeds.',
            ingredients: [
              'Raspberries',
              'Banana',
              'Coconut flakes',
              'Flax seeds',
              'Almond milk',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Seaweed Snacks & Edamame',
            calories: 140,
            description:
                'Crispy roasted seaweed snacks alongside a small bowl of steamed edamame.',
            ingredients: [
              'Roasted seaweed',
              'Edamame',
              'Sea salt',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Tofu Bibimbap',
            calories: 440,
            description:
                'A Korean rice bowl topped with marinated tofu, sauteed vegetables, and gochujang.',
            ingredients: [
              'Steamed rice',
              'Tofu',
              'Sauteed spinach',
              'Carrots',
              'Gochujang',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Palak Paneer',
            calories: 490,
            description:
                'Cubes of paneer in a silky spiced spinach sauce, served with steamed basmati rice.',
            ingredients: [
              'Paneer',
              'Spinach',
              'Cream',
              'Spices',
              'Basmati rice',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),

      // ============================================================
      // DAY 30
      // ============================================================
      DietDay(
        dayNumber: 30,
        standardMeals: [
          Meal(
            name: 'Celebration Brunch Platter',
            calories: 430,
            description:
                'A festive brunch platter with scrambled eggs, smoked salmon, fresh fruit, and pastries.',
            ingredients: [
              'Eggs',
              'Smoked salmon',
              'Croissant',
              'Fresh fruit',
              'Cream cheese',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Champagne Grapes & Cheese',
            calories: 170,
            description:
                'Tiny sweet champagne grapes paired with a selection of artisan cheese slices.',
            ingredients: [
              'Champagne grapes',
              'Brie cheese',
              'Gouda',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Lobster Roll',
            calories: 460,
            description:
                'Chilled lobster meat tossed in light mayo and served in a toasted buttered roll.',
            ingredients: [
              'Lobster meat',
              'Butter roll',
              'Light mayo',
              'Lemon',
              'Chives',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Filet Mignon & Veggies',
            calories: 540,
            description:
                'A tender filet mignon cooked to perfection with a red wine reduction and roasted vegetables.',
            ingredients: [
              'Filet mignon',
              'Red wine reduction',
              'Asparagus',
              'Baby potatoes',
              'Butter',
            ],
            mealTime: 'Dinner',
          ),
        ],
        vegetarianMeals: [
          Meal(
            name: 'Pancake Stack & Fresh Fruit',
            calories: 360,
            description:
                'A stack of fluffy buttermilk pancakes served with a colorful array of fresh fruit.',
            ingredients: [
              'Flour',
              'Buttermilk',
              'Eggs',
              'Fresh fruit medley',
              'Maple syrup',
            ],
            mealTime: 'Breakfast',
          ),
          Meal(
            name: 'Mango Lassi',
            calories: 150,
            description:
                'A chilled yogurt-based mango drink blended with cardamom and a touch of sugar.',
            ingredients: [
              'Mango',
              'Yogurt',
              'Cardamom',
              'Sugar',
            ],
            mealTime: 'Snack',
          ),
          Meal(
            name: 'Rainbow Veggie Bowl',
            calories: 430,
            description:
                'A vibrant bowl featuring an array of colorful roasted vegetables over brown rice with tahini.',
            ingredients: [
              'Brown rice',
              'Roasted beets',
              'Roasted carrots',
              'Avocado',
              'Tahini dressing',
            ],
            mealTime: 'Lunch',
          ),
          Meal(
            name: 'Grand Veggie Feast Platter',
            calories: 460,
            description:
                'A celebratory platter of stuffed mushrooms, grilled vegetables, hummus, and flatbread.',
            ingredients: [
              'Stuffed mushrooms',
              'Grilled vegetables',
              'Hummus',
              'Flatbread',
              'Olive tapenade',
            ],
            mealTime: 'Dinner',
          ),
        ],
      ),
    ];
  }
}
