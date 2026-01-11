# FlowKit Asset Catalog

This asset catalog contains all visual assets for the FlowKit application, including colors, icons, and the app icon.

## App Icon

The app icon features the "Glow" design - a warm, glowing orb with sparkles representing AI warmth and intelligence.

**Design Elements:**
- Warm gradient background (orange → pink → purple)
- Glowing white orb at center with radial gradient
- Six sparkles positioned around the orb
- Rounded corners with continuous curve style
- Optimized for all macOS icon sizes

**Sizes Included:**
- 16x16, 16x16@2x (32x32)
- 32x32, 32x32@2x (64x64)
- 128x128, 128x128@2x (256x256)
- 256x256, 256x256@2x (512x512)
- 512x512, 512x512@2x (1024x1024)

**Generation:**
Icons can be regenerated using `AppIconGenerator.swift` in the `Project/AppIcon` folder.

## Color Scheme

### Brand Colors

**BrandPrimary**
- Light: RGB(51, 102, 204) - Blue-purple
- Dark: RGB(102, 153, 230) - Lighter blue-purple
- Usage: Primary brand color, main UI elements

**BrandSecondary**
- Light: RGB(153, 77, 230) - Purple-pink
- Dark: RGB(179, 128, 242) - Lighter purple-pink
- Usage: Secondary accents, highlights

**BrandAccent**
- Light: RGB(255, 179, 102) - Warm orange
- Dark: RGB(255, 204, 128) - Lighter warm orange
- Usage: Call-to-action elements, important highlights

**AccentColor**
- Matches BrandAccent for system-wide accent color
- Used by macOS for focus rings, selection, etc.

### Semantic Colors

**SuccessColor**
- Light: RGB(51, 204, 77) - Green
- Dark: RGB(77, 230, 102) - Lighter green
- Usage: Success states, completed workflows, positive feedback

**WarningColor**
- Light: RGB(255, 179, 26) - Orange-yellow
- Dark: RGB(255, 204, 51) - Lighter orange-yellow
- Usage: Warning states, caution messages, pending actions

**ErrorColor**
- Light: RGB(255, 51, 77) - Red
- Dark: RGB(255, 77, 102) - Lighter red
- Usage: Error states, failed workflows, critical alerts

**InfoColor**
- Light: RGB(51, 153, 255) - Blue
- Dark: RGB(77, 179, 255) - Lighter blue
- Usage: Informational messages, tips, documentation

### Surface Colors

**SurfaceColor**
- Light: RGB(255, 255, 255) - White
- Dark: RGB(38, 38, 38) - Dark gray
- Usage: Card backgrounds, elevated surfaces, panels

**BackgroundColor**
- Light: RGB(250, 250, 250) - Off-white
- Dark: RGB(26, 26, 26) - Very dark gray
- Usage: Main background, window background

## SF Symbols Usage

The app uses SF Symbols for all UI icons. See `IconSystem.swift` for the complete icon mapping.

### Navigation Icons
- Dashboard: `chart.bar.fill`
- Chat: `message.fill`
- Projects: `folder.fill`
- History: `clock.arrow.circlepath`
- Workflows: `gearshape.2.fill`

### Action Icons
- Create: `plus.circle.fill`
- Execute: `play.circle.fill`
- Pause: `pause.circle.fill`
- Resume: `arrow.clockwise.circle.fill`
- Stop: `stop.circle.fill`
- Save: `checkmark.circle.fill`
- Delete: `trash.circle.fill`
- Edit: `pencil.circle.fill`
- Share: `square.and.arrow.up.circle.fill`

### State Icons
- Success: `checkmark.seal.fill`
- Warning: `exclamationmark.triangle.fill`
- Error: `xmark.octagon.fill`
- Info: `info.circle.fill`
- Loading: `arrow.triangle.2.circlepath`

### Workflow Category Icons
- Development: `hammer.fill`
- Testing: `checkmark.seal.fill`
- Deployment: `arrow.up.doc.fill`
- Documentation: `doc.text.fill`
- Analytics: `chart.line.uptrend.xyaxis`
- Automation: `wand.and.stars`
- Collaboration: `person.2.fill`
- Database: `cylinder.fill`
- API: `network`
- Git: `arrow.triangle.branch`
- Build: `shippingbox.fill`
- Debug: `ant.fill`
- Security: `lock.shield.fill`
- Performance: `speedometer`
- UI: `paintbrush.fill`
- Backend: `server.rack`
- Mobile: `iphone`
- Web: `globe`
- Cloud: `cloud.fill`
- AI: `brain.head.profile`

## Usage in Code

### Colors

```swift
// Brand colors
.foregroundStyle(Color.brandPrimary)
.background(Color.brandSecondary)

// Semantic colors
.foregroundStyle(Color.brandSuccess)
.foregroundStyle(Color.brandError)

// Surface colors
.background(Color.surfaceColor)
.background(Color.backgroundColor)
```

### Icons

```swift
// Using IconSystem
AnimatedIcon(.dashboard, color: .brandPrimary, size: 24)
IconButton(.create, color: .brandSuccess) { /* action */ }
IconWithBadge(.chat, badge: 5, color: .brandPrimary)

// Using WorkflowCategory
CategoryBadge(.development, size: .medium)
CategoryIcon(.testing, size: 48)
```

### Workflow Categories

```swift
// Get category info
let category = WorkflowCategory.development
let icon = category.icon
let color = category.color
let description = category.description

// Use in UI
CategoryPicker(selection: $selectedCategory, columns: 4)
CategoryListView(categories: categories) { category in
    // Handle selection
}
```

## Accessibility

All colors meet WCAG 2.1 AA contrast requirements:
- Text on backgrounds: minimum 4.5:1 contrast ratio
- Large text: minimum 3:1 contrast ratio
- UI components: minimum 3:1 contrast ratio

Dark mode variants are provided for all colors to ensure readability in both light and dark appearances.

## Design Guidelines

1. **Consistency**: Always use asset catalog colors instead of hardcoded RGB values
2. **Semantic Meaning**: Use semantic colors (success, error, warning, info) for their intended purposes
3. **Accessibility**: Test all color combinations for sufficient contrast
4. **Dark Mode**: All colors automatically adapt to dark mode
5. **SF Symbols**: Use SF Symbols for all icons to maintain consistency with macOS design language
6. **Category Colors**: Each workflow category has a unique color for easy visual identification

## Updating Assets

### Adding New Colors

1. Create a new `.colorset` folder in `Assets.xcassets`
2. Add `Contents.json` with light and dark variants
3. Update `IconSystem.swift` to add the color extension
4. Document the color in this README

### Adding New Icons

1. Find appropriate SF Symbol at https://developer.apple.com/sf-symbols/
2. Add to `CustomIcon` enum in `IconSystem.swift`
3. Add to appropriate category in `IconSystem`
4. Document in this README

### Regenerating App Icon

1. Open `AppIconGenerator.swift`
2. Modify the `AppIconDesign` view if needed
3. Run the generator or export from previews
4. Place generated images in `AppIcon.appiconset`

## Resources

- [SF Symbols Browser](https://developer.apple.com/sf-symbols/)
- [Apple Human Interface Guidelines - Color](https://developer.apple.com/design/human-interface-guidelines/color)
- [Apple Human Interface Guidelines - Icons](https://developer.apple.com/design/human-interface-guidelines/icons)
- [WCAG 2.1 Contrast Guidelines](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
