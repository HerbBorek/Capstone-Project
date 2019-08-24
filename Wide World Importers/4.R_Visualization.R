# Herbert Borek


WWI <- read.csv("World_Wide_Importers.csv")

require(ggplot2)


ggplot(data=WWI, aes(WWI$ROI)) +
  geom_histogram(col="blue", binwidth=8, aes(fill=Is.Finalized)) +
  labs(title="Wide World Importers ROI by Package") +
  labs(x="ROI", y="Count") +
  facet_grid(Package ~ Invoice.Year, labeller=label_both)


ggplot(data=WWI, aes(WWI$ROI)) +
  geom_histogram(col="blue", binwidth=15) +
  labs(title="Wide World Importers ROI by Package") +
  labs(x="ROI", y="Count") +
  facet_grid(Package ~ Invoice.Year, labeller=label_both)

ggplot(data=WWI, aes(WWI$ROI)) +
  geom_histogram(col="blue", binwidth=15, aes(fill=Package)) +
  labs(title="Wide World Importers ROI by Package") +
  labs(x="ROI", y="Count") +
  facet_grid(Is.Finalized ~ Invoice.Year, labeller=label_both)
