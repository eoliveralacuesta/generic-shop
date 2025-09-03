package products

type Service struct {
	repo Repository
}

func NewService(r Repository) *Service {
	return &Service{repo: r}
}

// Para testing
// func (s *Service) List(q Query) ([]Product, error) {
// 	return s.repo.List(q.Normalized())
// }

type Result struct {
	Items  []Product `json:"items"`
	Total  int       `json:"total"`
	Count  int       `json:"count"`
	Limit  int       `json:"limit"`
	Offset int       `json:"offset"`
}

func (s *Service) Find(q Query) (Result, error) {
	qn := q.Normalized()

	items, err := s.repo.Find(qn)
	if err == nil {
		total, err := s.repo.Count(qn)
		if err == nil {
			return Result{
				Items:  items,
				Count:  len(items),
				Total:  total,
				Offset: qn.Offset,
				Limit:  qn.Limit,
			}, nil
		}
	}

	return Result{}, err
}

func (s *Service) FindByID(id int) (Product, error) {
	return s.repo.FindByID(id)
}

func (s *Service) FindBySKU(sku string) (Product, error) {
	return s.repo.FindBySKU(sku)
}
